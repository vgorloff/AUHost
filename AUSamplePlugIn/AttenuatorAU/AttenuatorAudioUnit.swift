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

	public enum Error: ErrorType {
		case StatusError(OSStatus)
	}

	private var _parameterTree: AUParameterTree!
	private var _inputBusses: AUAudioUnitBusArray!
	private var _outputBusses: AUAudioUnitBusArray!
	private var _inputBus: BufferedInputBus!
	private var _outputBus: AUAudioUnitBus!

	// MARK: -
	override public var parameterTree: AUParameterTree? {
		return _parameterTree
	}
	override public var internalRenderBlock: AUInternalRenderBlock {
		return { [weak self] actionFlags, timestamp, frameCount, outputBusNumber, outputData, realtimeEventListHead, pullInputBlock in
			guard let s = self else { return kAudioUnitErr_NoConnection }
			var flags: AudioUnitRenderActionFlags = []
			let err = s._inputBus.pullInput(&flags, timestamp: timestamp, frameCount: frameCount,
				inputBusNumber: 0, pullInputBlock: pullInputBlock)
			guard err == noErr else {
				return err
			}

			let inAudioBufferList = UnsafeMutableAudioBufferListPointer(s._inputBus.mutableAudioBufferList!)
			let outAudioBufferList = UnsafeMutableAudioBufferListPointer(outputData)
			for index in 0 ..< outAudioBufferList.count {
//				if outAudioBufferList[index].mData == nil {
					outAudioBufferList[index].mData = inAudioBufferList[index].mData
				outAudioBufferList[index].mDataByteSize = inAudioBufferList[index].mDataByteSize
				outAudioBufferList[index].mNumberChannels = inAudioBufferList[index].mNumberChannels
//				}
			}
			return noErr
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
		guard _outputBus.format.channelCount == _inputBus.bus.format.channelCount else {
			setRenderResourcesAllocated(false)
			throw Error.StatusError(kAudioUnitErr_FailedInitialization)
		}
		_inputBus.allocateRenderResources(maximumFramesToRender)
	}

	public override func deallocateRenderResources() {
		super.deallocateRenderResources()
		_inputBus.deallocateRenderResources()
	}

	// MARK: - Private

	private func setUpBusses() throws {
		let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
		_inputBus = try BufferedInputBus(defaultFormat: defaultFormat, maxChannels: 8)
		_outputBus = try AUAudioUnitBus(format: defaultFormat)
		_inputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.Input, busses: [_inputBus.bus])
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

}