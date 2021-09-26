//
//  QuickLookProxy.Media.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import AVFoundation
import Foundation
import mcxFoundationTestability

extension QuickLookProxy { public struct Media {} }

extension QuickLookProxy.Media {

   public static func register() {
      QuickLookProxy.register(for: RingBuffer<Float>.self) {
         if let value = $0 as? RingBuffer<Float> {
            return .array1x(Array(value.bufferPointer))
         }
         return nil
      }
      QuickLookProxy.register(for: RingBuffer<OscilloscopeDSPValue<Float>>.self) {
         if let value = $0 as? RingBuffer<OscilloscopeDSPValue<Float>> {
            return .array1x(Array(value.bufferPointer).map { $0.average })
         }
         return nil
      }
      QuickLookProxy.register(for: MediaBuffer<Float>.self) {
         if let value = $0 as? MediaBuffer<Float> {
            return .array1x(Array(value.bufferPointer))
         }
         return nil
      }
      QuickLookProxy.register(for: MediaBuffer<Int32>.self) {
         if let value = $0 as? MediaBuffer<Int32> {
            return .array1x(Array(value.bufferPointer).map { Float($0) })
         }
         return nil
      }
      QuickLookProxy.register(for: MediaBuffer<OscilloscopeDSPValue<Float>>.self) {
         if let value = $0 as? MediaBuffer<OscilloscopeDSPValue<Float>> {
            return .array1x(Array(value.bufferPointer).map { $0.average })
         }
         return nil
      }
      QuickLookProxy.register(for: MediaBufferList<OscilloscopeDSPValue<Float>>.self) {
         if let value = $0 as? MediaBufferList<OscilloscopeDSPValue<Float>> {
            return .array2x(value.arrayOfBuffers.map { $0.bufferPointer.map { $0.average } })
         }
         return nil
      }
      QuickLookProxy.register(for: AVAudioBuffer.self) {
         if let avBuffer = $0 as? AVAudioPCMBuffer {
            if !avBuffer.format.isInterleaved {
               return .array2x(Array(avBuffer.audioBuffers.map { $0.mFloatArray }))
            } else {
               if let audioBuffer = avBuffer.audioBuffers.first { // Interleaved channels seems have only one buffer.
                  let buffer = audioBuffer.mFloatBuffer
                  let numChannels = Int(avBuffer.format.channelCount)
                  var resultData = Array(repeating: [Float](repeating: 0, count: Int(avBuffer.frameLength)), count: numChannels)
                  for frame in 0 ..< Int(avBuffer.frameLength) {
                     for channelIndex in 0 ..< numChannels {
                        let index = frame * numChannels + channelIndex
                        resultData[channelIndex][frame] = buffer[index]
                     }
                  }
                  return .array2x(resultData)
               } else {
                  return .array2x(Array(avBuffer.audioBuffers.map { $0.mFloatArray }))
               }
            }
         }

         if let buffer = $0 as? AVAudioBuffer {
            return .array2x(Array(buffer.audioBuffers.map { $0.mFloatArray }))
         }
         return nil
      }
   }
}
