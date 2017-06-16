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
      case playbackEngineStageChanged(PlaybackEngineStateMachine.State)
      case audioComponentsChanged
   }

   enum CoordinatorEvent {
      case noop
   }

   var viewHandler: ((ViewEvent) -> Void)?
   var coordinatorHandler: ((CoordinatorEvent) -> Void)?

   private var model = MainModel()
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
      model.eventHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .audioComponentChanged(let change):
            switch change {
            case .audioComponentRegistered:
               this.viewHandler?(.audioComponentsChanged)
            case .audioComponentInstanceInvalidated(let au, _):
               if au.component == this.selectedAUComponent?.audioComponent {
                  this.selectEffect(nil)
               } else {
                  this.viewHandler?(.audioComponentsChanged)
               }
            }
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
      viewHandler?(.loadingEffects(true))
      model.reloadEffects { [weak self] in guard let this = self else { return }
         this.availableEffects = $0
         this.viewHandler?(.loadingEffects(false))
      }

   }

   func selectEffect(_ component: AVAudioUnitComponent?) {
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
      model.selectPreset(preset)
   }

   func togglePlay() {
      model.togglePlay()
   }

   func processFileAtURL(_ url: URL) throws {
      try model.processFileAtURL(url)
   }
}
