//
//  BufferedAudioBus.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08/10/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import AVFoundation
import CoreAudio

@available(OSX 10.11, *)
public class BufferedAudioBus {

   fileprivate var maxFrames: AUAudioFrameCount = 0
   private var pcmBuffer: AVAudioPCMBuffer?
   fileprivate(set) var originalAudioBufferList: UnsafePointer<AudioBufferList>?
   public fileprivate(set) var mutableAudioBufferList: UnsafeMutablePointer<AudioBufferList>?
   public private(set) var bus: AUAudioUnitBus

   public init(format: AVAudioFormat, maxChannels: AVAudioChannelCount) throws {
      bus = try AUAudioUnitBus(format: format)
      bus.maximumChannelCount = maxChannels
   }

   public func allocateRenderResources(maxFrames: AUAudioFrameCount) {
      self.maxFrames = maxFrames
      pcmBuffer = AVAudioPCMBuffer(pcmFormat: bus.format, frameCapacity: maxFrames)
      pcmBuffer?.frameLength = maxFrames
      originalAudioBufferList = pcmBuffer?.audioBufferList
      mutableAudioBufferList = pcmBuffer?.mutableAudioBufferList
   }

   public func deallocateRenderResources() {
      pcmBuffer = nil
      originalAudioBufferList = nil
      mutableAudioBufferList = nil
   }
}

@available(OSX 10.11, *)
public class BufferedInputBus: BufferedAudioBus {

   private func prepareInputBufferList() {
      guard let mbl = mutableAudioBufferList, let bl = originalAudioBufferList else {
         return
      }
      let maxByteSize = maxFrames * UInt32(MemoryLayout<Float>.stride)
      mbl.pointee.mNumberBuffers = bl.pointee.mNumberBuffers
      let blp = UnsafeMutableAudioBufferListPointer(UnsafeMutablePointer(mutating: bl))
      let mblp = UnsafeMutableAudioBufferListPointer(mbl)
      assert(blp.count == mblp.count)
      for index in 0 ..< mblp.count {
         let b = blp[index]
         mblp[index].mNumberChannels = b.mNumberChannels
         mblp[index].mDataByteSize = maxByteSize
         mblp[index].mData = b.mData
      }
   }

   public func pull(actionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>, timestamp: UnsafePointer<AudioTimeStamp>,
                    frameCount: AUAudioFrameCount, inputBusNumber: Int, pullBlock: AURenderPullInputBlock) -> AUAudioUnitStatus {
      guard let mbl = mutableAudioBufferList else {
         return kAudioUnitErr_Uninitialized
      }
      prepareInputBufferList()
      return pullBlock(actionFlags, timestamp, frameCount, inputBusNumber, mbl)
   }
}

@available(OSX 10.11, *)
public class BufferedOutputBus: BufferedAudioBus {

   public func prepareOutputBufferList(_ outputBufferList: UnsafeMutablePointer<AudioBufferList>, frameCount: AUAudioFrameCount,
                                       zeroFill: Bool = false) {
      guard let busBufferList = originalAudioBufferList else {
         return
      }
      let byteSize = frameCount * UInt32(MemoryLayout<Float>.stride)
      let busBufferListPointer = UnsafeMutableAudioBufferListPointer(UnsafeMutablePointer(mutating: busBufferList))
      let outputBufferListPointer = UnsafeMutableAudioBufferListPointer(outputBufferList)
      assert(outputBufferListPointer.count <= busBufferListPointer.count)
      for index in 0 ..< outputBufferListPointer.count {
         let busBuffer = busBufferListPointer[index]
         outputBufferListPointer[index].mNumberChannels = busBuffer.mNumberChannels
         outputBufferListPointer[index].mDataByteSize = byteSize
         if outputBufferListPointer[index].mData == nil {
            outputBufferListPointer[index].mData = busBuffer.mData
         }
         if zeroFill, let outputBufferData = outputBufferListPointer[index].mData {
            var zero: Float = 0
            outputBufferData.initializeMemory(as: Float.self, from: &zero, count: Int(frameCount))
         }
      }
   }
}
