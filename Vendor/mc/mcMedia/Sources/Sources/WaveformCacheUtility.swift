//
//  WaveformCacheUtility.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.01.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Accelerate
import AVFoundation
import CoreAudio
import mcFoundation
import mcMath
import mcTypes

public struct WaveformCacheUtility {

   private enum Error: Swift.Error {
      case unableToInitialize(String)
   }

   private static var cache = [String: [MinMax<Float>]]()

   private static let defaultBufferFrameCapacity: UInt64 = 1024 * 8
   public init() {
   }

   public func cachedWaveformForResolution(url: URL, resolution: UInt64) -> [MinMax<Float>]? {
      let existedWaveform = WaveformCacheUtility.cache[WaveformCacheUtility.cacheID(url: url, resolution: resolution)]
      if let wf = existedWaveform {
         return wf
      }
      return nil
   }

   public func buildWaveformForResolution(fileURL url: URL, resolution: UInt64,
                                          callback: @escaping (Result<[MinMax<Float>]>) -> Void) {
      assert(resolution > 0)
      DispatchQueue.global(qos: .utility).async {
         do {
            defer {
               url.stopAccessingSecurityScopedResource() // Seems working fine without this line
            }
            _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
            let audioFile = try AVAudioFile(forReading: url, commonFormat: .pcmFormatFloat32, interleaved: false)
            let optimalBufferSettings = Math.optimalBufferSizeForResolution(resolution: resolution, dataSize: UInt64(audioFile.length),
                                                                            maxBufferSize: WaveformCacheUtility.defaultBufferFrameCapacity)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat,
                                                frameCapacity: AVAudioFrameCount(optimalBufferSettings.optimalBufferSize)) else {
               throw Error.unableToInitialize(String(describing: AVAudioPCMBuffer.self))
            }

            var waveformCache = [MinMax<Float>]()
            var groupingBuffer = [MinMax<Float>]()
            while audioFile.framePosition < audioFile.length {
               try audioFile.read(into: buffer)
               let data = WaveformCacheUtility.processBuffer(buffer: buffer)
               groupingBuffer.append(data)
               if groupingBuffer.count >= Int(optimalBufferSettings.numberOfBuffers) {
                  assert(groupingBuffer.count > 0)
                  let waveformValue = groupingBuffer.suffix(from: 1).reduce(groupingBuffer[0]) { prev, el in
                     MinMax(min: prev.min + el.min, max: prev.max + el.max)
                  }
                  let avarageValue = MinMax(min: waveformValue.min / Float(groupingBuffer.count),
                                            max: waveformValue.max / Float(groupingBuffer.count))
                  waveformCache.append(avarageValue)
                  groupingBuffer.removeAll(keepingCapacity: true)
               }
            }
            assert(UInt64(waveformCache.count) == resolution)
            WaveformCacheUtility.cache[WaveformCacheUtility.cacheID(url: url, resolution: resolution)] = waveformCache
            callback(.success(waveformCache))
         } catch {
            callback(.failure(error))
         }
      }
   }

   private static func cacheID(url: URL, resolution: UInt64) -> String {
      return "WaveForm:\(resolution):\(url.absoluteString)"
   }

   private static func processBuffer(buffer: AVAudioPCMBuffer) -> MinMax<Float> {

      //		let numElementsToProcess = vDSP_Length(buffer.frameLength * buffer.format.channelCount)
      //		var maximumMagnitudeValue: Float = 0
      //		var minimumMagnitudeValue: Float = 0
      //		vDSP_maxv(buffer.floatChannelData.memory, 1, &maximumMagnitudeValue, numElementsToProcess)
      //		vDSP_minv(buffer.floatChannelData.memory, 1, &minimumMagnitudeValue, numElementsToProcess)
      //		Swift.print(minimumMagnitudeValue, maximumMagnitudeValue, "\n")

      // Swift.print(buffer.frameLength)
      var channelValues = [MinMax<Float>]()
      let mbl = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
      for index in 0 ..< mbl.count {
         let bl = mbl[index]
         guard let samplesBI = bl.mData?.assumingMemoryBound(to: Float.self) else {
            continue
         }
         let numElementsToProcess = vDSP_Length(buffer.frameLength)
         var maximumMagnitudeValue: Float = 0
         var minimumMagnitudeValue: Float = 0
         vDSP_maxv(samplesBI, 1, &maximumMagnitudeValue, numElementsToProcess)
         vDSP_minv(samplesBI, 1, &minimumMagnitudeValue, numElementsToProcess)
         // Swift.print(minimumMagnitudeValue, maximumMagnitudeValue)
         channelValues.append(MinMax(min: minimumMagnitudeValue, max: maximumMagnitudeValue))
      }
      assert(channelValues.count > 0)
      let result = channelValues.suffix(from: 1).reduce(channelValues[0]) { prev, el in
         MinMax(min: prev.min + el.min, max: prev.max + el.max)
      }
      return MinMax(min: result.min / Float(channelValues.count), max: result.max / Float(channelValues.count))
   }
}
