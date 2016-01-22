//
//  BufferedAudioBus.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 22.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import AudioUnit

public class BufferedAudioBus {
	public final var bus: AUAudioUnitBus!
	private final var maxFrames: AUAudioFrameCount = 0
	private final var pcmBuffer: AVAudioPCMBuffer?
	private final var originalAudioBufferList: UnsafePointer<AudioBufferList>?
	final var mutableAudioBufferList: UnsafeMutablePointer<AudioBufferList>?

	public init(defaultFormat: AVAudioFormat, maxChannels: AVAudioChannelCount) throws {
		bus = try AUAudioUnitBus(format: defaultFormat)
		bus.maximumChannelCount = maxChannels
	}
	public final func allocateRenderResources(inMaxFrames: AUAudioFrameCount) {
		maxFrames = inMaxFrames
		let buffer = AVAudioPCMBuffer(PCMFormat: bus.format, frameCapacity: inMaxFrames)
		originalAudioBufferList = buffer.audioBufferList
		mutableAudioBufferList = buffer.mutableAudioBufferList
		pcmBuffer = buffer
	}
	public final func deallocateRenderResources() {
		originalAudioBufferList = nil
		mutableAudioBufferList = nil
		pcmBuffer = nil
	}
	deinit {
		deallocateRenderResources()
	}
}

public final class BufferedInputBus: BufferedAudioBus {

	public final func pullInput(actionFlags: UnsafeMutablePointer<AudioUnitRenderActionFlags>,
		timestamp: UnsafePointer<AudioTimeStamp>, frameCount: AVAudioFrameCount, inputBusNumber: Int,
		pullInputBlock: AURenderPullInputBlock?) -> AUAudioUnitStatus {
			guard let pullBlock = pullInputBlock else {
				return kAudioUnitErr_NoConnection
			}
			guard let mbl = mutableAudioBufferList else {
				return kAudioUnitErr_Uninitialized
			}
			prepareInputBufferList()
			return pullBlock(actionFlags, timestamp, frameCount, inputBusNumber, mbl)
	}
	private final func prepareInputBufferList() {
		guard let mbl = mutableAudioBufferList, let obl = originalAudioBufferList else {
			return
		}

		let byteSize = maxFrames * UInt32(sizeof(Float.self))
		mbl.memory.mNumberBuffers = obl.memory.mNumberBuffers
		let mblPointer = UnsafeMutableAudioBufferListPointer(mbl)
		let oblPointer = UnsafeMutableAudioBufferListPointer(UnsafeMutablePointer<AudioBufferList>(obl))
		for index in 0 ..< Int(obl.memory.mNumberBuffers) {
			mblPointer[index].mNumberChannels = oblPointer[index].mNumberChannels
			mblPointer[index].mData = oblPointer[index].mData
			mblPointer[index].mDataByteSize = byteSize
		}
	}
}
