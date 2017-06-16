//
//  MainModel.swift
//  AUHost
//
//  Created by VG (DE) on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AVFoundation

class MainModel {

   enum Event {
      case audioComponentChanged(AudioComponentsUtility.StateChange)
   }

   var eventHandler: ((Event) -> Void)?

   private var audioUnitDatasource = AudioComponentsUtility()

   init() {
      audioUnitDatasource.handlerStateChange = { [weak self] change in guard let s = self else { return }
         s.eventHandler?(.audioComponentChanged(change))
      }
   }

   func reloadEffects(completion: (([AVAudioUnitComponent]) -> Void)?) {
      audioUnitDatasource.updateEffectList {
         completion?($0)
      }
   }

   func selectEffect(_ effect: AVAudioUnitComponent?, completion: ((PlaybackEngineStateMachine.EffectSelectionResult) -> Void)?) {
      let engine = Application.sharedInstance.playbackEngine
      engine.selectEffect(component: effect) {
         completion?($0)
      }
   }

   func selectPreset(_ preset: AUAudioUnitPreset?) {
      let engine = Application.sharedInstance.playbackEngine
      engine.selectPreset(preset: preset)
   }

   func togglePlay() {
      let engine = Application.sharedInstance.playbackEngine
      do {
         switch engine.stateID {
         case .Playing:
            engine.pause()
         case .Paused:
            try engine.resume()
         case .Stopped:
            try engine.play()
         case .SettingEffect, .SettingFile: break
         }
      } catch {
         Logger.error(subsystem: .controller, category: .handle, message: error)
      }
   }

   func processFileAtURL(_ url: URL) throws {
      let engine = Application.sharedInstance.playbackEngine
      let f = try AVAudioFile(forReading: url)
      try engine.setFileToPlay(f)
      if engine.stateID == .Stopped {
         try engine.play()
      }
   }
   
}
