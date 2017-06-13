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
      case statusError(OSStatus)
      case unableToInitialize(String)
   }
   private let maxChannels = UInt32(8)
   private var _parameterTree: AUParameterTree!
   private var _inputBusses: AUAudioUnitBusArray!
   private var _outputBusses: AUAudioUnitBusArray!
   internal private(set) var inputBus: BufferedInputBus!
   internal private(set) var outputBus: BufferedOutputBus!
   private(set) var dsp: AttenuatorDSPKernel
   internal private(set) var parameterGain: AUParameter!
//   public override var canProcessInPlace: Bool {
//      return true
//   }

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
         guard let s = self, let pullBlock = pullInputBlock, let inputBus = s.inputBus, let outputBus = s.outputBus,
         let inputBufferList = inputBus.mutableAudioBufferList else {
            return kAudioUnitErr_NoConnection
         }

         var pullFlags: AudioUnitRenderActionFlags = []
         var status = inputBus.pull(actionFlags: &pullFlags, timestamp: timestamp, frameCount: frameCount,
                                    inputBusNumber: 0, pullBlock: pullBlock)
         guard status == noErr else {
            return status
         }
         let outputBufferList = outputData
         outputBus.prepareOutputBufferList(outputBufferList, frameCount: frameCount, zeroFill: false)
         status = s.dsp.processInputBufferList(inAudioBufferList: inputBufferList,
                                               outputBufferList: outputBufferList, frameCount: frameCount)
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
      guard outputBus.bus.format.channelCount == inputBus.bus.format.channelCount else {
         setRenderResourcesAllocated(false)
         throw Errors.statusError(kAudioUnitErr_FailedInitialization)
      }
      inputBus.allocateRenderResources(maxFrames: maximumFramesToRender)
      outputBus.allocateRenderResources(maxFrames: maximumFramesToRender)
      dsp.reset()
      eventHandler?(.allocateRenderResources)
   }

   public override func deallocateRenderResources() {
      inputBus.deallocateRenderResources()
      outputBus.deallocateRenderResources()
      super.deallocateRenderResources()
   }

   // MARK: - Private

   private func setUpBusses() throws {
      guard let defaultFormat = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 2) else {
         throw Errors.unableToInitialize(String(describing: AVAudioFormat.self))
      }
      inputBus = try BufferedInputBus(format: defaultFormat, maxChannels: maxChannels)
      outputBus = try BufferedOutputBus(format: defaultFormat, maxChannels: maxChannels)
      _inputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.input, busses: [inputBus.bus])
      _outputBusses = AUAudioUnitBusArray(audioUnit: self, busType: AUAudioUnitBusType.output, busses: [outputBus.bus])
   }

   private func setUpParametersTree() -> AUParameterTree {
      let pGain = AttenuatorParameter.gain
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
