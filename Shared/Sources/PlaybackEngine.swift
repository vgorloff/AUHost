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

   struct Change {
      let event: Event
      let oldState: State
      let newState: State
      var shouldChange: Bool {
         return oldState != newState
      }
   }

   enum State: Int {
      case Stopped, Playing, Paused, updatingGraph
   }

   enum Event: Int {
      case Play, Pause, Resume, Stop, SetFile, SetEffect, Autostop
   }

   enum EffectSelectionResult {
      case EffectCleared
      case Success(AVAudioUnit)
      case Failure(Error)
   }

   var changeHandler: Completion<Change>?

   private let context = PlaybackEngineContext()
   private let _stateAccessLock: NonRecursiveLocking = SpinLock()
   private var stateIDValue: State = .Stopped
   private(set) var stateID: State {
      get {
         return _stateAccessLock.synchronized {
            return stateIDValue
         }
      } set {
         return _stateAccessLock.synchronized {
            stateIDValue = newValue
         }
      }
   }

   init() {
      setupHandlers()
      Logger.initialize(subsystem: .media)
   }

   deinit {
      Logger.deinitialize(subsystem: .media)
   }

}

extension PlaybackEngine {

   func setFileToPlay(_ fileToPlay: AVAudioFile) {
      let change1 = Change(event: .SetFile, oldState: stateID, newState: .updatingGraph)
      guard change1.shouldChange else {
         return
      }
      notifyAboutChange(change1)
      switch change1.oldState {
      case .updatingGraph, .Stopped:
         break
      case .Playing, .Paused:
         context.stop()
      }
      let change2 = Change(event: .SetFile, oldState: change1.newState, newState: .Stopped)
      context.setFileToPlay(fileToPlay)
      notifyAboutChange(change2)
   }

   func stop() {
      let change = Change(event: .SetFile, oldState: stateID, newState: .Stopped)
      if change.shouldChange  {
         switch change.oldState {
         case .Paused, .Playing:
            context.stop()
         case .updatingGraph, .Stopped:
            break
         }
         notifyAboutChange(change)
      }
   }

   func pause() throws {
      let change = Change(event: .Pause, oldState: stateID, newState: .Paused)
      if change.shouldChange {
         switch change.oldState {
         case .Paused, .Stopped, .updatingGraph:
            break
         case .Playing:
            context.pause()
         }
         notifyAboutChange(change)
      }
   }

   func resume() throws {
      let change = Change(event: .Resume, oldState: stateID, newState: .Playing)
      if change.shouldChange {
         switch change.oldState  {
         case .updatingGraph, .Stopped, .Playing:
            break
         case .Paused:
            try context.resume()
         }
         notifyAboutChange(change)
      }
   }

   func play() throws {
      let change = Change(event: .Play, oldState: stateID, newState: .Playing)
      if change.shouldChange {
         switch change.oldState  {
         case .Playing, .Paused, .updatingGraph:
            break
         case .Stopped:
            try context.play()
         }
         notifyAboutChange(change)
      }
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

   func selectEffect(componentDescription: AudioComponentDescription?, completion: ((EffectSelectionResult) -> Void)?) {
      let change1 = Change(event: .SetEffect, oldState: stateID, newState: .updatingGraph)
      guard change1.shouldChange else {
         return
      }
      notifyAboutChange(change1)
      switch change1.oldState {
      case .updatingGraph, .Stopped:
         break
      case .Paused, .Playing:
         context.stopPlayer()
      }
      let change2 = Change(event: .SetEffect, oldState: change1.newState, newState: change1.oldState)
      let restartCallback: () -> Void = { [weak self] in
         switch change2.newState {
         case .Playing:
            do {
               try self?.context.startPlayer()
            } catch {
               Logger.error(subsystem: .media, category: .generic, message: error)
            }
         case .Paused:
            do {
               try self?.context.scheduleFile()
            } catch {
               Logger.error(subsystem: .media, category: .generic, message: error)
            }
         case .Stopped ,.updatingGraph:
            break
         }
         self?.notifyAboutChange(change2)
      }
      DispatchQueue.UserInitiated.async { [weak self] in
         self?.context.selectEffect(componentDescription: componentDescription) { result in
            DispatchQueue.main.async {
               completion?(result)
               restartCallback()
            }
         }
      }
   }

}

extension PlaybackEngine {

   private func setupHandlers() {
      context.filePlaybackCompleted = { [weak self] in guard let s = self else { return }
         let change = Change(event: .Autostop, oldState: s.stateID, newState: .Stopped)
         let message = "Playback stopped or file finished playing. Current state: \(change.oldState)"
         Logger.debug(subsystem: .media, category: .handle, message: message)
         if change.oldState == .Playing {
            DispatchQueue.main.async { [weak self] in guard let s = self else { return }
               s.context.stop()
               s.notifyAboutChange(change)
            }
         }
      }
   }

   private func notifyAboutChange(_ change: Change) {
      stateID = change.newState
      Logger.debug(subsystem: .media, category: .handle, message: "State changed: \(change.oldState) => \(change.newState)")
      DispatchQueue.main.async {
         self.changeHandler?(change)
      }
   }


}
