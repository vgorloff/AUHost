//
//  AttenuatorDSPKernel.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 25.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation
import AudioUnit
import AVFoundation
import Accelerate

struct AttenuatorDSPKernel {

   typealias SampleType = Float32

   private var valueGain: AUValue = AttenuatorParameter.Gain.defaultValue
   private var dspValueGain: AUValue = AttenuatorParameter.Gain.defaultValue / AttenuatorParameter.Gain.max
   private let valueGainLock: NonRecursiveLocking = SpinLock()

   private var _maximumMagnitude: [SampleType]
   var maximumMagnitude: [SampleType] {
      return maximumMagnitudeLock.synchronized { return _maximumMagnitude }
   }
   private let maximumMagnitudeLock: NonRecursiveLocking = SpinLock()

   init(maxChannels: UInt32) {
      _maximumMagnitude = Array<SampleType>(repeating: 0, count: Int(maxChannels))
   }

   func getParameter(_ parameter: AttenuatorParameter) -> AUValue {
      switch parameter {
      case .Gain:
         return valueGainLock.synchronized { return valueGain }
      }
   }

   mutating func setParameter(_ parameter: AttenuatorParameter, value: AUValue) {
      switch parameter {
      case .Gain:
         valueGainLock.synchronized {
            valueGain = value
            dspValueGain = value / AttenuatorParameter.Gain.max
         }
      }
   }

   mutating func reset() {
      setParameter(.Gain, value: AttenuatorParameter.Gain.defaultValue)
   }

   mutating func processInputBufferList(inAudioBufferList: UnsafeMutablePointer<AudioBufferList>,
                                        outputBufferList: UnsafeMutablePointer<AudioBufferList>,
                                        frameCount: AVAudioFrameCount) -> AUAudioUnitStatus {

      // 2. Now we have PCM buffer filled with some data. Lets process it.
      // Number of input and output buffers in our case is equal.
      let blI = UnsafeMutableAudioBufferListPointer(inAudioBufferList)
      let blO = UnsafeMutableAudioBufferListPointer(outputBufferList)
      for index in 0 ..< blO.count {
         var bO = blO[index]
         let bI = blI[index]
         guard let inputData = bI.mData else {
            continue
         }
         let outputData: UnsafeMutableRawPointer
         if let bOData = bO.mData { // Might be a nil?
            outputData = bOData
         } else {
            bO.mData = bI.mData
            outputData = inputData
            //assert(false)
         }
         // We are expecting one buffer per channel.
         assert(bI.mNumberChannels == bO.mNumberChannels && bI.mNumberChannels == 1)
         assert(bI.mDataByteSize == bO.mDataByteSize)
         let samplesBI = UnsafePointer<SampleType>(inputData.assumingMemoryBound(to: SampleType.self))
         let samplesBO = outputData.assumingMemoryBound(to: SampleType.self)
         #if false
            var gain = dspValueGain
            var maximumMagnitudeValue: Float = 0
            let numElementsToProcess = vDSP_Length(frameCount)
            vDSP_vsmul(samplesBI, 1, &gain, samplesBO, 1, numElementsToProcess)
            vDSP_maxmgv(samplesBO, 1, &maximumMagnitudeValue, numElementsToProcess)
            _maximumMagnitude[index] = maximumMagnitudeLock.synchronized {
               return maximumMagnitudeValue
            }
         #else
            // Applying gain by math
            let numSamples = Int(bO.mDataByteSize / UInt32(MemoryLayout<SampleType>.stride))
            assert(AVAudioFrameCount(numSamples) == frameCount)
            let samplesI = UnsafeBufferPointer<SampleType>(start: samplesBI, count: numSamples)
            let samplesO = UnsafeMutableBufferPointer<SampleType>(start: samplesBO, count: numSamples)
            var maximumMagnitudeValue: SampleType = 0
            for sampleIndex in 0 ..< samplesI.count {
               let sampleValue = samplesI[sampleIndex]
               samplesO[sampleIndex] = dspValueGain * sampleValue
               if sampleValue > maximumMagnitudeValue {
                  maximumMagnitudeValue = sampleValue
               }
            }
            _maximumMagnitude[index] = maximumMagnitudeLock.synchronized {
               return maximumMagnitudeValue
            }
         #endif
      }
      return noErr
   }

}
