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

   public enum Errors: Error {
      case StatusError(OSStatus)
   }
   private let maxChannels = UInt32(8)
   private var _parameterTree: AUParameterTree!
   private var _inputBusses: AUAudioUnitBusArray!
   private var _outputBusses: AUAudioUnitBusArray!
   internal private(set) var inputBus: AUAudioUnitBus!
   internal private(set) var outputBus: AUAudioUnitBus!
   private var _pcmBuffer: AVAudioPCMBuffer?
   private(set) var dsp: AttenuatorDSPKernel
   internal private(set) var parameterGain: AUParameter!

   enum Event {
      case allocateRenderResources
   }

   var eventHandler: ((Event) -> Void)?

   // MARK: - Public
   override public var parameterTree: AUParameterTree {
      return _parameterTree
   }
   override public var internalRenderBlock: AUInternalRenderBlock {
      return { [weak self] actionFlags, timestamp, frameCount, outputBusNumber, outputData,
         realtimeEventListHead, pullInputBlock in
         guard let s = self, let pullBlock = pullInputBlock, let pcmBuffer = s._pcmBuffer else {
            return kAudioUnitErr_NoConnection
         }

         let renderFlags = actionFlags.pointee
//         let bl = UnsafeMutableAudioBufferListPointer(UnsafeMutablePointer(mutating: pcmBuffer.audioBufferList))
//         let mbl = UnsafeMutableAudioBufferListPointer(pcmBuffer.mutableAudioBufferList)
//         pcmBuffer.mutableAudioBufferList.pointee.mNumberBuffers = pcmBuffer.audioBufferList.pointee.mNumberBuffers
//         for index in 0 ..< bl.count {
//            let b = bl[index]
//            var mb = mbl[index]
//            mb.mNumberChannels = b.mNumberChannels
//            mb.mData = b.mData
//            mb.mDataByteSize = s.maximumFramesToRender * UInt32(MemoryLayout<Float>.stride)
//         }

         pcmBuffer.frameLength = frameCount
         let buffer = pcmBuffer.mutableAudioBufferList
         var pullFlags: AudioUnitRenderActionFlags = []
         var status = pullBlock(&pullFlags, timestamp, frameCount, 0, buffer)
         guard status == noErr else {
            return status
         }
         status = s.dsp.processInputBufferList(inAudioBufferList: buffer, outputBufferList: outputData, frameCount: frameCount)
         return status
      }
   }

   override public var inputBusses: AUAudioUnitBusArray {
      return _inputBusses
   }

   override public var outputBusses: AUAudioUnitBusArray {
      return _outputBusses
   }

   // MARK: - Init * Deinit

   public override init(componentDescription: AudioComponentDescription, options: AudioComponentInstantiationOptions) throws {
      dsp = AttenuatorDSPKernel(maxChannels: maxChannels)
      try super.init(componentDescription: componentDescription, options: options)
      _parameterTree = setUpParametersTree()
      try setUpBusses()
      maximumFramesToRender = 512
   }

   public override func allocateRenderResources() throws {
      try super.allocateRenderResources()
      guard outputBus.format.channelCount == inputBus.format.channelCount else {
         setRenderResourcesAllocated(false)
         throw Errors.StatusError(kAudioUnitErr_FailedInitialization)
      }
      _pcmBuffer = AVAudioPCMBuffer(pcmFormat: inputBus.format, frameCapacity: maximumFramesToRender)
      dsp.reset()
      eventHandler?(.allocateRenderResources)
   }

   public override func deallocateRenderResources() {
      super.deallocateRenderResources()
      _pcmBuffer = nil
   }

   // MARK: - Private

   private func setUpBusses() throws {
      let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2)
      inputBus = try AUAudioUnitBus(format: defaultFormat)
      outputBus = try AUAudioUnitBus(format: defaultFormat)
      outputBus.maximumChannelCount = maxChannels // Use supportedChannelCounts.
      _inputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.input, busses: [inputBus])
      _outputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.output, busses: [outputBus])
   }

   private func setUpParametersTree() -> AUParameterTree {
      let pGain = AttenuatorParameter.Gain
      parameterGain = AUParameterTree.createParameter(withIdentifier: pGain.parameterID,
                                                      name: pGain.name, address: pGain.rawValue, min: pGain.min, max: pGain.max,
                                                      unit: AudioUnitParameterUnit.percent, unitName: nil, flags: [],
                                                      valueStrings: nil, dependentParameters: nil)
      parameterGain.value = pGain.defaultValue
      let tree = AUParameterTree.createTree(withChildren: [parameterGain])
      tree.implementorStringFromValueCallback = { param, value in
         guard let paramValue = value?.pointee else {
            return "-"
         }
         let param = AttenuatorParameter.fromRawValue(param.address)
         return param.stringFromValue(value: paramValue)
      }
      tree.implementorValueObserver = { [weak self] param, value in guard let s = self else { return }
         let param = AttenuatorParameter.fromRawValue(param.address)
         return s.dsp.setParameter(param, value: value)
      }
      tree.implementorValueProvider = { [weak self] param in guard let s = self else { return AUValue() }
         let param = AttenuatorParameter.fromRawValue(param.address)
         return s.dsp.getParameter(param)
      }
      return tree
   }

}
