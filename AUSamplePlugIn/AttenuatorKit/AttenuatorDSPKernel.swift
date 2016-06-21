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
		_maximumMagnitude = Array<SampleType>(count: Int(maxChannels), repeatedValue: 0)
	}

	func getParameter(parameter: AttenuatorParameter) -> AUValue {
		switch parameter {
		case .Gain:
			return valueGainLock.synchronized { return valueGain }
		}
	}

	mutating func setParameter(parameter: AttenuatorParameter, value: AUValue) {
		switch parameter {
		case .Gain:
			valueGainLock.synchronized {
				valueGain = value
				dspValueGain = value / AttenuatorParameter.Gain.max
			}
		}
	}

	mutating func reset() {
		setParameter(AttenuatorParameter.Gain, value:  AttenuatorParameter.Gain.defaultValue)
	}

	mutating func processInputBufferList(inAudioBufferList: UnsafeMutablePointer<AudioBufferList>,
		outputBufferList: UnsafeMutablePointer<AudioBufferList>, frameCount: AVAudioFrameCount) -> AUAudioUnitStatus {

			// 2. Now we have PCM buffer filled with some data. Lets process it.
			// Number of input and output buffers in our case is equal.
			let blI = UnsafeMutableAudioBufferListPointer(inAudioBufferList)
			let blO = UnsafeMutableAudioBufferListPointer(outputBufferList)
			for index in 0 ..< blO.count {
				let bO = blO[index]
				let bI = blI[index]
				if bO.mData == nil { // Might be a nil
					bO.mData.memory = bI.mData.memory
					assert(false)
				}
				// We are expecting one buffer per channel.
				assert(bI.mNumberChannels == bO.mNumberChannels && bI.mNumberChannels == 1)
				assert(bI.mDataByteSize == bO.mDataByteSize)
				let samplesBI = UnsafePointer<SampleType>(bI.mData)
				let samplesBO = UnsafeMutablePointer<SampleType>(bO.mData)
				#if true
					var gain = dspValueGain
					var maximumMagnitudeValue: Float = 0
					let numElementsToProcess = vDSP_Length(frameCount)
					vDSP_vsmul(samplesBI, 1, &gain, samplesBO, 1, numElementsToProcess)
					vDSP_maxmgv(samplesBO, 1, &maximumMagnitudeValue, numElementsToProcess)
					_maximumMagnitude[index] = maximumMagnitudeLock.synchronized{ return maximumMagnitudeValue }
				#else
					// Applying gain by math
					let numSamples = Int(bO.mDataByteSize / UInt32(sizeof(SampleType.self)))
					let samplesI = UnsafeBufferPointer<SampleType>(start: samplesBI, count: numSamples)
					let samplesO = UnsafeMutableBufferPointer<SampleType>(start: samplesBO, count: numSamples)
					for sampleIndex in 0 ..< samplesI.count {
						samplesO[sampleIndex] = dspValueGain * samplesI[sampleIndex]
					}
				#endif
			}
			return noErr
	}
	
}