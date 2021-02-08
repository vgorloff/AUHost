//
//  SinewaveToneGenerator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Accelerate
import AVFoundation
import CoreAudio
import mcMediaExtensions

public class SinewaveToneGenerator {

   var isUsedAccelerate: Bool = true // Just for testability.

   public var amplitude: Float = 1
   public var frequency: Float = 440 // Hz

   private var currentPhase: Float = 0

   private var tmpBuffer1 = [Float](repeating: 0, count: 2048)
   private var tmpBuffer2 = [Float](repeating: 0, count: 2048)

   public init(frequency: Float = 440) {
      self.frequency = frequency
   }
}

extension SinewaveToneGenerator {

   public func reset() {
      currentPhase = 0
   }

   public func render(ioData: UnsafeMutablePointer<AudioBufferList>, numberOfFrames: UInt32, audioFormat: AVAudioFormat) {
      let audioBuffers = UnsafeMutableAudioBufferListPointer(ioData).audioBuffers
      render(ioData: audioBuffers, numberOfFrames: numberOfFrames, audioFormat: audioFormat)
   }

   public func render(_ ioData: AudioBufferProcessingInfo) {
      render(ioData: ioData.audioBuffers, numberOfFrames: ioData.numberOfFrames, audioFormat: ioData.audioFormat)
   }

   public func render(_ ioData: AVAudioPCMBuffer) {
      let audioBuffers = UnsafeMutableAudioBufferListPointer(ioData.mutableAudioBufferList).audioBuffers
      render(ioData: audioBuffers, numberOfFrames: ioData.frameLength, audioFormat: ioData.format)
   }

   public func render(ioData: [AudioBuffer], numberOfFrames: UInt32, audioFormat: AVAudioFormat) {
      let phaseIncrement = 2.0 * Float.pi * frequency / Float(audioFormat.sampleRate)
      if isUsedAccelerate {
         renderUsingAccelerate(ioData: ioData, numberOfFrames: numberOfFrames, audioFormat: audioFormat,
                               phaseIncrement: phaseIncrement)
      } else {
         renderUsingMath(ioData: ioData, numberOfFrames: numberOfFrames, audioFormat: audioFormat,
                         phaseIncrement: phaseIncrement)
      }
      currentPhase = (currentPhase + phaseIncrement * Float(numberOfFrames)).truncatingRemainder(dividingBy: 2.0 * Float.pi)
   }

   func renderUsingAccelerate(ioData: [AudioBuffer], numberOfFrames: UInt32, audioFormat: AVAudioFormat, phaseIncrement: Float) {
      if tmpBuffer1.count < Int(numberOfFrames) {
         tmpBuffer1 = [Float](repeating: 0, count: Int(numberOfFrames))
         tmpBuffer2 = [Float](repeating: 0, count: Int(numberOfFrames))
      }

      var phaseIncrement = phaseIncrement
      var phase = currentPhase
      // tmpBuffer1 will contains "phases"
      vDSP_vramp(&phase, &phaseIncrement, &tmpBuffer1, 1, UInt(numberOfFrames))
      var numberOfElements = Int32(numberOfFrames)
      // tmpBuffer2 will contains "sinuses"
      vvsinf(&tmpBuffer2, &tmpBuffer1, &numberOfElements)
      // tmpBuffer1 will contains "sinuses with attenuation"
      DSP.vsmul(inputVector: &tmpBuffer2, inputScalar: amplitude, outputVector: &tmpBuffer1,
                numberOfElements: UInt(numberOfFrames))

      tmpBuffer1.withUnsafeMutableBufferPointer { buffer in
         guard let address = buffer.baseAddress else {
            return
         }
         for outputChanneldata in ioData {
            let sampleData = outputChanneldata.mFloatData
            if audioFormat.isInterleaved == false {
               sampleData?.moveInitialize(from: address, count: Int(numberOfFrames))
            } else {
               for frame in 0 ..< Int(numberOfFrames) {
                  for channelIndex in 0 ..< Int(audioFormat.channelCount) {
                     let index = frame * Int(audioFormat.channelCount) + channelIndex
                     sampleData?[index] = tmpBuffer1[frame]
                  }
               }
            }
         }
      }
   }

   func renderUsingMath(ioData: [AudioBuffer], numberOfFrames: UInt32, audioFormat: AVAudioFormat, phaseIncrement: Float) {

      let numberOfChannels = Int(audioFormat.channelCount)
      for index in 0 ..< ioData.count {
         let outputChanneldata = ioData[index]
         let sampleData = outputChanneldata.mFloatBuffer

         // Loop through the callback buffer, generating samples
         var phase = currentPhase
         for frame in 0 ..< Int(numberOfFrames) {
            let value = sin(phase) * amplitude
            phase += phaseIncrement
            if audioFormat.isInterleaved == false {
               sampleData[frame] = value
            } else {
               for channelIndex in 0 ..< numberOfChannels {
                  let index = frame * numberOfChannels + channelIndex
                  sampleData[index] = value
               }
            }
         }
      }
   }
}
