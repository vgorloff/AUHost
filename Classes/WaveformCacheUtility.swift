//
//  WaveformCacheUtility.swift
//  WLMedia
//
//  Created by Volodymyr Gorlov on 28.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Accelerate
import AVFoundation

public struct WaveformCacheUtility {

	private static let cache: NSCache = CacheCentre.cacheForIdentifier("WaveformCacheUtility")

	private static let defaultBufferFrameCapacity: UInt64 = 1024 * 8
	public init() {
	}

	public func cachedWaveformForResolution(url: NSURL, resolution: UInt64) -> [MinMax<Float>]? {
		let existedWaveform: [MinMax<Float>]? = WaveformCacheUtility.cache.objectValueForKey(
			WaveformCacheUtility.cacheID(url, resolution: resolution))
		if let wf = existedWaveform {
			return wf
		}
		return nil
	}

	public func buildWaveformForResolution(fileURL url: NSURL, resolution: UInt64, callback: ResultType<[MinMax<Float>]> -> Void) {
		assert(resolution > 0)
		Dispatch.Async.UserInitiated {
			do {
				defer {
					url.stopAccessingSecurityScopedResource() // Seems working fine without this line
				}
				url.startAccessingSecurityScopedResource() // Seems working fine without this line
				let audioFile = try AVAudioFile(forReading: url, commonFormat: .PCMFormatFloat32, interleaved: false)
				let optimalBufferSettings = Math.optimalBufferSizeForResolution(resolution, dataSize: UInt64(audioFile.length),
					maxBufferSize: WaveformCacheUtility.defaultBufferFrameCapacity)
				let buffer = AVAudioPCMBuffer(PCMFormat: audioFile.processingFormat,
					frameCapacity: AVAudioFrameCount(optimalBufferSettings.optimalBufferSize))

				var waveformCache = Array<MinMax<Float>>()
				var groupingBuffer = Array<MinMax<Float>>()
				while audioFile.framePosition < audioFile.length {
					try audioFile.readIntoBuffer(buffer)
					let data = WaveformCacheUtility.processBuffer(buffer)
					groupingBuffer.append(data)
					if groupingBuffer.count >= Int(optimalBufferSettings.numberOfBuffers) {
						assert(groupingBuffer.count > 0)
						let waveformValue = groupingBuffer.suffixFrom(1).reduce(groupingBuffer[0]) { prev, el in
							return MinMax(min: prev.min + el.min, max: prev.max + el.max)
						}
						let avarageValue = MinMax(min: waveformValue.min / Float(groupingBuffer.count),
							max: waveformValue.max / Float(groupingBuffer.count))
						waveformCache.append(avarageValue)
						groupingBuffer.removeAll(keepCapacity: true)
					}
				}
				assert(UInt64(waveformCache.count) == resolution)
				WaveformCacheUtility.cache.setObjectValue(waveformCache, forKey: WaveformCacheUtility.cacheID(url, resolution: resolution))
				callback(.Success(waveformCache))
			} catch {
				callback(.Failure(error))
			}
		}
	}

	private static func cacheID(url: NSURL, resolution: UInt64) -> String {
		return "WaveForm:\(resolution):\(url.absoluteString)"
	}

	private static func processBuffer(buffer: AVAudioPCMBuffer) -> MinMax<Float> {

		//		let numElementsToProcess = vDSP_Length(buffer.frameLength * buffer.format.channelCount)
		//		var maximumMagnitudeValue: Float = 0
		//		var minimumMagnitudeValue: Float = 0
		//		vDSP_maxv(buffer.floatChannelData.memory, 1, &maximumMagnitudeValue, numElementsToProcess)
		//		vDSP_minv(buffer.floatChannelData.memory, 1, &minimumMagnitudeValue, numElementsToProcess)
		//		Swift.print(minimumMagnitudeValue, maximumMagnitudeValue, "\n")

		//Swift.print(buffer.frameLength)
		var channelValues = [MinMax<Float>]()
		let mbl = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
		for index in 0 ..< mbl.count {
			let bl = mbl[index]
			let samplesBI = UnsafePointer<Float>(bl.mData)
			let numElementsToProcess = vDSP_Length(buffer.frameLength)
			var maximumMagnitudeValue: Float = 0
			var minimumMagnitudeValue: Float = 0
			vDSP_maxv(samplesBI, 1, &maximumMagnitudeValue, numElementsToProcess)
			vDSP_minv(samplesBI, 1, &minimumMagnitudeValue, numElementsToProcess)
			//Swift.print(minimumMagnitudeValue, maximumMagnitudeValue)
			channelValues.append(MinMax(min: minimumMagnitudeValue, max: maximumMagnitudeValue))
		}
		assert(channelValues.count > 0)
		let result = channelValues.suffixFrom(1).reduce(channelValues[0]) { prev, el in
			return MinMax(min: prev.min + el.min, max: prev.max + el.max)
		}
		return MinMax(min: result.min / Float(channelValues.count), max: result.max / Float(channelValues.count))
	}
}
