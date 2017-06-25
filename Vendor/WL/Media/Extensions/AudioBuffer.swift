//
//  AudioBuffer.swift
//  WaveLabs
//
//  Created by VG (DE) on 23.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
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
