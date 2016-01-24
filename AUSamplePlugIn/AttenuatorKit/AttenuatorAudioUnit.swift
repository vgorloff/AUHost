//
//  AttenuatorAudioUnit.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 22.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AudioUnit
import AVFoundation

public final class AttenuatorAudioUnit: AUAudioUnit {

	private typealias SampleType = Float32

	public enum Error: ErrorType {
		case StatusError(OSStatus)
	}

	private var _parameterTree: AUParameterTree!
	private var _inputBusses: AUAudioUnitBusArray!
	private var _outputBusses: AUAudioUnitBusArray!
	private var _inputBus: AUAudioUnitBus!
	private var _outputBus: AUAudioUnitBus!
	private var _pcmBuffer: AVAudioPCMBuffer?

	// MARK: -
	override public var parameterTree: AUParameterTree? {
		return _parameterTree
	}
	override public var internalRenderBlock: AUInternalRenderBlock {
		return { [weak self] actionFlags, timestamp, frameCount, outputBusNumber, outputData, realtimeEventListHead, pullInputBlock in
			guard let s = self, let pullBlock = pullInputBlock, let pcmBuffer = s._pcmBuffer else {
				return kAudioUnitErr_NoConnection
			}
			s.prepareInputBuffer(pcmBuffer, frameCount: s.maximumFramesToRender)
			let buffer = pcmBuffer.mutableAudioBufferList
			var flags: AudioUnitRenderActionFlags = []
			let status = pullBlock(&flags, timestamp, frameCount, 0, buffer)
			guard status == noErr else {
				return status
			}
			return s.processInputBufferList(buffer, outputBufferList: outputData, frameCount: frameCount)
		}
	}

	override public var inputBusses: AUAudioUnitBusArray {
		return _inputBusses
	}

	override public var outputBusses: AUAudioUnitBusArray {
		return _outputBusses
	}

	public override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
		try super.init(componentDescription: componentDescription, options: options)
		_parameterTree = setUpParametersTree()
		try setUpBusses()
		maximumFramesToRender = 512
	}

	public override func allocateRenderResources() throws {
		try super.allocateRenderResources()
		guard _outputBus.format.channelCount == _inputBus.format.channelCount else {
			setRenderResourcesAllocated(false)
			throw Error.StatusError(kAudioUnitErr_FailedInitialization)
		}
		_pcmBuffer = AVAudioPCMBuffer(PCMFormat: _inputBus.format, frameCapacity: maximumFramesToRender)
	}

	public override func deallocateRenderResources() {
		super.deallocateRenderResources()
		_pcmBuffer = nil
	}

	// MARK: - Private

	private func setUpBusses() throws {
		let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
		_inputBus = try AUAudioUnitBus(format: defaultFormat)
		_outputBus = try AUAudioUnitBus(format: defaultFormat)
		_outputBus.maximumChannelCount = 8 // Use supportedChannelCounts.
		_inputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.Input, busses: [_inputBus])
		_outputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.Output, busses: [_outputBus])
	}

	private func setUpParametersTree() -> AUParameterTree {
		let pGain = AttenuatorParameter.Gain
		let paramGain = AUParameterTree.createParameterWithIdentifier(pGain.parameterID,
			name: pGain.name, address: pGain.rawValue, min: pGain.min, max: pGain.max,
			unit: AudioUnitParameterUnit.Percent, unitName: nil, flags: [], valueStrings: nil, dependentParameters: nil)
		paramGain.value = pGain.defaultValue
		let tree = AUParameterTree.createTreeWithChildren([paramGain])
		tree.implementorStringFromValueCallback = { param, value in
			let paramValue = value.memory
			let param = AttenuatorParameter.fromRawValue(param.address)
			return param.stringFromValue(paramValue)
		}
		tree.implementorValueObserver = { param, value in
		// FIXME: set value to kernel. By Vlad Gorlov, Jan 22, 2016.
		}
		tree.implementorValueProvider = { param in
			return 100 // FIXME: Use value from kernel. By Vlad Gorlov, Jan 22, 2016.
		}
		return tree
	}

	private final func prepareInputBuffer(buffer: AVAudioPCMBuffer, frameCount: AUAudioFrameCount) {
		let mbl = buffer.mutableAudioBufferList
		let abl = buffer.audioBufferList
		let byteSize = frameCount * UInt32(sizeof(SampleType.self))
		mbl.memory.mNumberBuffers = abl.memory.mNumberBuffers
		let mblPointer = UnsafeMutableAudioBufferListPointer(mbl)
		let ablPointer = UnsafeMutableAudioBufferListPointer(UnsafeMutablePointer<AudioBufferList>(abl))
		for index in 0 ..< ablPointer.count {
			var mB = mblPointer[index]
			let aB = ablPointer[index]
			mB.mNumberChannels = aB.mNumberChannels
			mB.mData = aB.mData
			mB.mDataByteSize = byteSize
		}
	}

	private final func processInputBufferList(inAudioBufferList: UnsafeMutablePointer<AudioBufferList>,
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
				// Now we chould copy the data.
				let numSamples = Int(bO.mDataByteSize / UInt32(sizeof(SampleType.self)))
				let samplesI = UnsafeBufferPointer<SampleType>(start: samplesBI, count: numSamples)
				let samplesO = UnsafeMutableBufferPointer<SampleType>(start: samplesBO, count: numSamples)
				for sampleIndex in 0 ..< samplesI.count {
					samplesO[sampleIndex] = 0.3 * samplesI[sampleIndex]
				}
			}
			return noErr
	}


}
