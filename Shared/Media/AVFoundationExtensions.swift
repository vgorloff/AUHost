//
//  AVFoundationExtensions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.06.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation

extension AudioBuffer {
   public var mFloatData: UnsafeMutablePointer<Float>? {
      return mData?.assumingMemoryBound(to: Float.self)
   }
   public var mDoubleData: UnsafeMutablePointer<Double>? {
      return mData?.assumingMemoryBound(to: Double.self)
   }
   public var mFloatBuffer: UnsafeMutableBufferPointer<Float> {
      return UnsafeMutableBufferPointer<Float>(start: mFloatData, count: Int(mDataByteSize) / MemoryLayout<Float>.stride)
   }
   public var mDoubleBuffer: UnsafeMutableBufferPointer<Double> {
      return UnsafeMutableBufferPointer<Double>(start: mDoubleData, count: Int(mDataByteSize) / MemoryLayout<Double>.stride)
   }
   public var mFloatArray: [Float] {
      return Array(mFloatBuffer)
   }
   public var mDoubleArray: [Double] {
      return Array(mDoubleBuffer)
   }
   public func fillWithZeros() {
      memset(mData, 0, Int(mDataByteSize))
   }
}

public extension AudioComponentDescription {
   public init(type: OSType, subType: OSType, manufacturer: OSType = kAudioUnitManufacturer_Apple,
               flags: UInt32 = 0, flagsMask: UInt32 = 0) {
      self.init(componentType: type, componentSubType: subType, componentManufacturer: manufacturer,
                componentFlags: flags, componentFlagsMask: flagsMask)
   }
}

extension UnsafeMutableAudioBufferListPointer {
   public var audioBuffers: [AudioBuffer] {
      var result = [AudioBuffer]()
      for audioBufferIndex in 0..<count {
         result.append(self[audioBufferIndex])
      }
      return result
   }
   init(unsafePointer pointer: UnsafePointer<AudioBufferList>) {
      self.init(UnsafeMutablePointer<AudioBufferList>(mutating: pointer))
   }
}
