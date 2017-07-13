//
//  AttenuatorDSPKernel.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 25.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import Accelerate
import AudioUnit
import Foundation

struct AttenuatorDSPKernel {

   typealias SampleType = Float32

   private var valueGain: AUValue = AttenuatorParameter.gain.defaultValue
   private var dspValueGain: AUValue = AttenuatorParameter.gain.defaultValue / AttenuatorParameter.gain.max
   private let valueGainLock: NonRecursiveLocking = SpinLock()

   private var _maximumMagnitude: [SampleType]
   var maximumMagnitude: [SampleType] {
      return maximumMagnitudeLock.synchronized { _maximumMagnitude }
   }

   private let maximumMagnitudeLock: NonRecursiveLocking = SpinLock()

   init(maxChannels: UInt32) {
      _maximumMagnitude = Array(repeating: 0, count: Int(maxChannels))
   }

   func getParameter(_ parameter: AttenuatorParameter) -> AUValue {
      switch parameter {
      case .gain:
         return valueGainLock.synchronized { valueGain }
      }
   }

   mutating func setParameter(_ parameter: AttenuatorParameter, value: AUValue) {
      switch parameter {
      case .gain:
         valueGainLock.synchronized {
            valueGain = value
            dspValueGain = value / AttenuatorParameter.gain.max
         }
      }
   }

   mutating func reset() {
      setParameter(.gain, value: AttenuatorParameter.gain.defaultValue)
   }

   mutating func processInputBufferList(inAudioBufferList: UnsafeMutablePointer<AudioBufferList>,
                                        outputBufferList: UnsafeMutablePointer<AudioBufferList>,
                                        frameCount: AVAudioFrameCount) -> AUAudioUnitStatus {

      // 2. Now we have PCM buffer filled with some data. Lets process it.
      // Number of input and output buffers in our case is equal.
      let blI = UnsafeMutableAudioBufferListPointer(inAudioBufferList)
      let blO = UnsafeMutableAudioBufferListPointer(outputBufferList)
      for index in 0 ..< blO.count {
         let bI = blI[index]
         var bO = blO[index]
         guard let inputData = bI.mData, let outputData = bO.mData else {
            assert(false)
            return kAudioUnitErr_Uninitialized
         }

         // We are expecting one buffer per channel.
         assert(bI.mNumberChannels == bO.mNumberChannels && bI.mNumberChannels == 1)
         assert(bI.mDataByteSize == bO.mDataByteSize)
         let samplesBI = UnsafePointer<SampleType>(inputData.assumingMemoryBound(to: SampleType.self))
         let samplesBO = outputData.assumingMemoryBound(to: SampleType.self)
         #if true
            var gain = dspValueGain
            var maximumMagnitudeValue: Float = 0
            let numElementsToProcess = vDSP_Length(frameCount)
            vDSP_vsmul(samplesBI, 1, &gain, samplesBO, 1, numElementsToProcess)
            vDSP_maxmgv(samplesBO, 1, &maximumMagnitudeValue, numElementsToProcess)
            _maximumMagnitude[index] = maximumMagnitudeLock.synchronized {
               return maximumMagnitudeValue
            }
         #else
            // Applying gain by math
            let numSamples = Int(bO.mDataByteSize / UInt32(MemoryLayout<SampleType>.stride))
            assert(AVAudioFrameCount(numSamples) == frameCount)
            let samplesI = UnsafeBufferPointer<SampleType>(start: samplesBI, count: numSamples)
            let samplesO = UnsafeMutableBufferPointer<SampleType>(start: samplesBO, count: numSamples)
            var maximumMagnitudeValue: SampleType = 0
            for sampleIndex in 0 ..< samplesI.count {
               let sampleValue = samplesI[sampleIndex]
               samplesO[sampleIndex] = dspValueGain * sampleValue
               if sampleValue > maximumMagnitudeValue {
                  maximumMagnitudeValue = sampleValue
               }
            }
            _maximumMagnitude[index] = maximumMagnitudeLock.synchronized {
               return maximumMagnitudeValue
            }
         #endif
      }
      return noErr
   }
}
