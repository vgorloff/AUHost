//
//  OscilloscopeAlgorithm.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.09.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Accelerate
import AVFoundation
import CoreAudio
import Foundation

public final class OscilloscopeAlgorithm<T: BinaryFloatingPoint & DefaultInitializerType> {

   private var bytesPerFrame = MemoryLayout<T>.stride
   var shouldUseMathInsteadOfDSP = false
   private let unprocessedFrames: MediaBufferCollection<T>
   private let calculatedValues: MediaBufferCollection<OscilloscopeDSPValue<T>>
   private var offsets = OscilloscopeOffsetCalculation()
   private var channelsData = [UnsafeMutableRawPointer?]()

   public init() {
      guard T.self == Float.self || T.self == Double.self else {
         fatalError("Unsupported floating point type: \(T.self). Please use Float or Double.")
      }
      unprocessedFrames = MediaBufferCollection<T>()
      calculatedValues = MediaBufferCollection<OscilloscopeDSPValue<T>>()
   }
}

extension OscilloscopeAlgorithm {

   public func process(abl: UnsafePointer<AudioBufferList>,
                       numberOfFrames: Int, framesInGroup: Int) -> MediaBufferCollection<OscilloscopeDSPValue<T>> {
      defer {
         channelsData.removeAll(keepingCapacity: true)
      }

      let ablPointer = UnsafeMutableAudioBufferListPointer(unsafePointer: abl)
      let numberOfChannels = ablPointer.count

      for channel in 0 ..< numberOfChannels {
         let channelBuffer = ablPointer[channel]
         var isChannelDataProcessable = true
         // Supporting non interleaved channels at the moment
         if channelBuffer.mNumberChannels != 1 || channelBuffer.mDataByteSize != numberOfFrames * bytesPerFrame {
            isChannelDataProcessable = false
            assert(false)
         }
         if isChannelDataProcessable, let channelBufferRawData = channelBuffer.mData {
            channelsData.append(channelBufferRawData)
         } else {
            channelsData.append(nil)
         }
      }

      offsets = OscilloscopeOffsetCalculation(numberOfFrames: numberOfFrames, framesInGroup: framesInGroup,
                                              pendingFrames: unprocessedFrames.numberOfElements)

      calculatedValues.resize(numberOfBuffers: numberOfChannels,
                              numberOfElements: offsets.buffer.processingIterations + offsets.tail.processingIterations)

      unprocessedFrames.resize(numberOfBuffers: numberOfChannels, numberOfElements: offsets.tail.processingFrames)
      for channel in 0 ..< channelsData.count {
         let channelBufferRawData = channelsData[channel]
         calculate(tailOfChannel: channel, channelBufferRawData: channelBufferRawData, framesInGroup: framesInGroup)
         calculate(channel: channel, channelBufferRawData: channelBufferRawData, framesInGroup: framesInGroup)
      }
      storeUnprocessedFarmesIfNeeded()
      return calculatedValues
   }
}

extension OscilloscopeAlgorithm {

   private func storeUnprocessedFarmesIfNeeded() {

      let numberOfBuffers = channelsData.count
      let numberOfElements = offsets.unprocessedFramesBufferSize
      if numberOfElements > 0 {
         unprocessedFrames.resize(numberOfBuffers: numberOfBuffers, numberOfElements: numberOfElements)
         let framesToWrite = offsets.unprocessedFramesBufferNumberOfFramesToWrite
         let bytesToWrite = Int(bytesPerFrame * framesToWrite)
         let positionReadOffset = Int(offsets.buffer.processingOffset + offsets.buffer.processingFrames)
         for channel in 0 ..< channelsData.count {
            let positionWrite = unprocessedFrames[channel].mutableData.advanced(by: Int(offsets.tail.pendingFrames))
            if let channelBufferData = channelsData[channel]?.assumingMemoryBound(to: T.self) {
               let positionRead = channelBufferData.advanced(by: positionReadOffset)
               memcpy(positionWrite, positionRead, bytesToWrite)
            } else {
               memset(positionWrite, 0, bytesToWrite)
            }
         }
      } else {
         unprocessedFrames.resize(numberOfBuffers: numberOfBuffers, numberOfElements: 0)
      }
   }

   private func calculate(tailOfChannel channel: Int, channelBufferRawData: UnsafeMutableRawPointer?, framesInGroup: Int) {
      guard offsets.tail.processingIterations > 0 else {
         return
      }
      if let positionRead = channelBufferRawData?.assumingMemoryBound(to: T.self) {
         let positionWrite = unprocessedFrames[channel].mutableData.advanced(by: Int(offsets.tail.pendingFrames))
         let bytesToCopy = Int(bytesPerFrame * offsets.buffer.processingOffset)
         // First copy pending frames
         memcpy(positionWrite, positionRead, bytesToCopy)
         // Calculate pending iterations
         let unprocessedBufferData = UnsafeMutableRawPointer(unprocessedFrames[channel].mutableData)
         for iteration in 0 ..< offsets.tail.processingIterations {
            let resultValue = calculateDSPValue(elementsToSkip: iteration * framesInGroup,
                                                channelBufferRawData: unprocessedBufferData, framesInGroup: framesInGroup)
            calculatedValues[channel].mutableData[Int(iteration)] = resultValue
         }
      } else {
         // Channel not available. "Zeroing" output.
         let resultValue = OscilloscopeDSPValue<T>()
         for iteration in 0 ..< offsets.tail.processingIterations {
            calculatedValues[channel].mutableData[iteration] = resultValue
         }
      }
   }

   private func calculate(channel: Int, channelBufferRawData: UnsafeMutableRawPointer?, framesInGroup: Int) {
      guard offsets.buffer.processingIterations > 0 else {
         return
      }
      if let channelBufferRawData = channelBufferRawData {
         for iteration in 0 ..< offsets.buffer.processingIterations {
            let offset = offsets.buffer.processingOffset + iteration * framesInGroup
            let resultValue: OscilloscopeDSPValue<T>
            if shouldUseMathInsteadOfDSP {
               resultValue = calculateUsingMath(elementsToSkip: offset,
                                                channelBufferRawData: channelBufferRawData, framesInGroup: framesInGroup)
            } else {
               resultValue = calculateDSPValue(elementsToSkip: offset,
                                               channelBufferRawData: channelBufferRawData, framesInGroup: framesInGroup)
            }
            calculatedValues[channel].mutableData[offsets.tail.processingIterations + iteration] = resultValue
         }
      } else {
         let resultValue = OscilloscopeDSPValue<T>()
         for iteration in 0 ..< offsets.buffer.processingIterations {
            calculatedValues[channel].mutableData[offsets.tail.processingIterations + iteration] = resultValue
         }
      }
   }

   private func calculateDSPValue(elementsToSkip: Int, channelBufferRawData: UnsafeMutableRawPointer, framesInGroup: Int)
      -> OscilloscopeDSPValue<T> {
      let framesInGroup = UInt(framesInGroup)
      if T.self == Float.self {
         let channelBufferData = channelBufferRawData.assumingMemoryBound(to: Float.self)
         var minValue: Float = 0
         var averageValue: Float = 0
         var maxValue: Float = 0
         let positionRead = channelBufferData.advanced(by: Int(elementsToSkip))
         vDSP_minv(positionRead, 1, &minValue, framesInGroup)
         vDSP_meanv(positionRead, 1, &averageValue, framesInGroup)
         vDSP_maxv(positionRead, 1, &maxValue, framesInGroup)
         let resultValue = OscilloscopeDSPValue(min: T(minValue), max: T(maxValue), average: T(averageValue))
         return resultValue
      } else if T.self == Double.self {
         let channelBufferData = channelBufferRawData.assumingMemoryBound(to: Double.self)
         var minValue: Double = 0
         var averageValue: Double = 0
         var maxValue: Double = 0
         let positionRead = channelBufferData.advanced(by: Int(elementsToSkip))
         vDSP_minvD(positionRead, 1, &minValue, framesInGroup)
         vDSP_meanvD(positionRead, 1, &averageValue, framesInGroup)
         vDSP_maxvD(positionRead, 1, &maxValue, framesInGroup)
         let resultValue = OscilloscopeDSPValue(min: T(minValue), max: T(maxValue), average: T(averageValue))
         return resultValue
      } else {
         fatalError("Unsupported floating point type: \(T.self). Please use Float or Double.")
      }
   }

   private func calculateUsingMath(elementsToSkip: Int, channelBufferRawData: UnsafeMutableRawPointer, framesInGroup: Int)
      -> OscilloscopeDSPValue<T> {
      let channelBufferData = channelBufferRawData.assumingMemoryBound(to: T.self).advanced(by: Int(elementsToSkip))
      var minValue: T = 0
      var averageValue: T = 0
      var maxValue: T = 0
      for frameNumber in 0 ..< framesInGroup {
         let sample = channelBufferData[frameNumber]
         if maxValue < sample {
            maxValue = sample
         }
         if minValue > sample {
            minValue = sample
         }
         averageValue += sample
      }
      averageValue /= T(framesInGroup)
      let resultValue = OscilloscopeDSPValue(min: minValue, max: maxValue, average: averageValue)
      return resultValue
   }
}
