//
//  AudioBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.06.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation

extension AudioBuffer {
	var mFloatData: UnsafeMutablePointer<Float> {
		return UnsafeMutablePointer<Float>(mData)
	}
	var mFloatBuffer: UnsafeMutableBufferPointer<Float> {
		return UnsafeMutableBufferPointer<Float>(start: mFloatData, count: Int(mDataByteSize) / sizeof(Float))
	}
	var mFloatArray: [Float] {
		return Array<Float>(mFloatBuffer)
	}
	func fillWithZeros() {
		memset(mData, 0, Int(mDataByteSize))
	}
}
