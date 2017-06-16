//
//  MainViewModel.swift
//  AUHost
//
//  Created by VG (DE) on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation
import AVFoundation

class MainViewModel {

   enum ViewEvent {
      case loadingEffects(Bool)
      case willSelectEffect
      case didSelectEffect(Error?)
      case playbackEngineStageChanged(PlaybackEngineState)
   }

   enum CoordinatorEvent {
      case noop
   }

   var viewHandler: ((ViewEvent) -> Void)?
   var coordinatorHandler: ((CoordinatorEvent) -> Void)?

   var model: MainModel?
   private(set) var selectedAUComponent: AVAudioUnitComponent?
   private(set) var availableEffects = [AVAudioUnitComponent]()
   private(set) var availablePresets = [AUAudioUnitPreset]()

   init() {
      let engine = Application.sharedInstance.playbackEngine
      engine.changeHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .EngineStateChanged(_, let new):
            this.viewHandler?(.playbackEngineStageChanged(new))
         }
      }
   }

   var canOpenEffectView: Bool {
      guard let component = selectedAUComponent else {
         return false
      }
      let flags = AudioComponentFlags(rawValue: component.audioComponentDescription.componentFlags)
      let v3AU = flags.contains(AudioComponentFlags.isV3AudioUnit)
      return component.hasCustomView || v3AU
   }

   func reloadEffects() {
      guard let model = model else {
         return
      }
      viewHandler?(.loadingEffects(true))
      model.reloadEffects { [weak self] in guard let this = self else { return }
         this.availableEffects = $0
         this.viewHandler?(.loadingEffects(false))
      }

   }

   func selectEffect(_ component: AVAudioUnitComponent?) {
      guard let model = model else {
         return
      }
      viewHandler?(.willSelectEffect)
      model.selectEffect(component) { [weak self, weak component] in guard let this = self else { return }
         switch $0 {
         case .EffectCleared:
            this.availablePresets.removeAll()
            this.viewHandler?(.didSelectEffect(nil))
         case .Failure(let e):
            Logger.error(subsystem: .controller, category: .handle, message: e)
            this.viewHandler?(.didSelectEffect(e))
         case .Success(let effect):
            this.availablePresets = effect.auAudioUnit.factoryPresets ?? []
            this.selectedAUComponent = component
            this.viewHandler?(.didSelectEffect(nil))
         }
      }
   }

   func selectPreset(_ preset: AUAudioUnitPreset?) {
      guard let model = model else {
         return
      }
      model.selectPreset(preset)
   }

   func togglePlay() {
      guard let model = model else {
         return
      }
      model.togglePlay()
   }

   func processFileAtURL(_ url: URL) throws {
      guard let model = model else {
         return
      }
      try model.processFileAtURL(url)
   }
}
