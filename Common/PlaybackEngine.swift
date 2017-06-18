//
//  PlaybackEngine.swift
//  AUHost
//
//  Created by Vlad Gorlov on 17.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import CoreAudioKit

final class PlaybackEngine {

   enum Change {
      case EngineStateChanged(old: PlaybackEngineStateMachine.State, new: PlaybackEngineStateMachine.State)
   }

   private var sm: StateMachine<PlaybackEngineStateMachine.State, PlaybackEngineStateMachine.Event, PlaybackEngineContext>
   private let context = PlaybackEngineContext()
   private let _stateAccessLock: NonRecursiveLocking = SpinLock()

   var changeHandler: ((Change) -> Void)?
   var stateID: PlaybackEngineStateMachine.State {
      return _stateAccessLock.synchronized {
         return sm.state
      }
   }

   init() {
      sm = StateMachine(context: context, graph: PlaybackEngineStateMachine.stateMachineGraph)
      sm.stateChangeHandler = { [weak self] oldState, event, newState in
         Logger.debug(subsystem: .media, category: .handle, message: "State changed: \(oldState) => \(newState)")
         DispatchQueue.main.async { [weak self] in
            self?.changeHandler?(Change.EngineStateChanged(old: oldState, new: newState))
         }
      }
      context.filePlaybackCompleted = { [weak self] in guard let s = self else { return }
         Logger.debug(subsystem: .media, category: .handle, message: "Playback stopped or file finished playing. Current state: \(s.stateID)")
         guard s.stateID == .Playing else {
            return
         }
         DispatchQueue.main.async { [weak self] in guard let s = self else { return }
            do {
               try s.sm.handleEvent(event: .Stop)
            } catch {
               Logger.error(subsystem: .media, category: .handle, message: error)
            }
         }
      }
      Logger.initialize(subsystem: .media)
   }

   deinit {
      Logger.deinitialize(subsystem: .media)
   }

}

extension PlaybackEngine {

   func setFileToPlay(_ fileToPlay: AVAudioFile) throws {
      switch stateID {
      case .SettingEffect, .SettingFile, .Stopped: break
      case .Playing, .Paused:
         try sm.handleEvent(event: .Stop)
      }
      try sm.handleEvent(event: .SetFile(fileToPlay))
      try sm.handleEvent(event: .Stop)
   }

   func stop() {
      do {
         try sm.handleEvent(event: .Stop)
      } catch {
         Logger.error(subsystem: .media, category: .lifecycle, message: error)
      }
   }

   func pause() {
      do {
         try sm.handleEvent(event: .Pause)
      } catch {
         Logger.error(subsystem: .media, category: .lifecycle, message: error)
      }
   }

   func resume() throws {
      try sm.handleEvent(event: .Resume)
   }

   func play() throws {
      try sm.handleEvent(event: .Play)
   }

   func openEffectView(completionHandler: @escaping (NSViewController?) -> Void) {
      if let au = context.effect?.auAudioUnit {
         au.requestViewController(completionHandler: completionHandler)
      } else {
         completionHandler(nil)
      }
   }

   func selectPreset(preset: AUAudioUnitPreset?) {
      guard let avau = context.effect else {
         return
      }
      guard let p = preset else {
         avau.auAudioUnit.currentPreset = nil
         return
      }
      let presetList = avau.auAudioUnit.factoryPresets ?? []
      let matchedPresets = presetList.filter { $0.number == p.number }
      guard let matchedPreset = matchedPresets.first else {
         avau.auAudioUnit.currentPreset = nil
         return
      }
      avau.auAudioUnit.currentPreset = matchedPreset
   }
}

extension PlaybackEngine {

   func selectEffect(componentDescription: AudioComponentDescription?,
                     completionHandler: ((PlaybackEngineStateMachine.EffectSelectionResult) -> Void)?) {
      var possibleRelaunchEvent: PlaybackEngineStateMachine.Event?
      switch stateID {
      case .SettingEffect, .SettingFile: break
      case .Stopped: possibleRelaunchEvent = .Stop
      case .Paused: possibleRelaunchEvent = .Pause
      case .Playing: possibleRelaunchEvent = .Play
      }
      let sema = DispatchSemaphore(value: 0)
      let event = PlaybackEngineStateMachine.Event.SetEffect(componentDescription) { result in
         DispatchQueue.main.async {
            completionHandler?(result)
            sema.signal()
         }
      }
      DispatchQueue.UserInitiated.async { [weak self] in guard let s = self else { return }
         do {
            try s.sm.handleEvent(event: event)
         } catch {
            Logger.error(subsystem: .media, category: .request, message: error)
         }
         sema.wait() {
            guard let relaunchEvent = possibleRelaunchEvent else {
               return
            }
            do {
               try s.sm.handleEvent(event: relaunchEvent)
            } catch {
               Logger.error(subsystem: .media, category: .request, message: error)
            }
         }
      }
   }
}
