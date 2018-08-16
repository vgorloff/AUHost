//
//  PlaybackEngine.swift
//  AUHost
//
//  Created by Vlad Gorlov on 17.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AVFoundation
import CoreAudioKit
import mcBase

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
      case stopped, playing, paused, updatingGraph
   }

   enum Event: Int {
      case play, pause, resume, stop, setFile, setEffect, autostop
   }

   enum EffectSelectionResult {
      case effectCleared
      case success(AVAudioUnit)
      case failure(Error)
   }

   var changeHandler: Completion<Change>?

   private let context = PlaybackEngineContext()
   private let _stateAccessLock: NonRecursiveLocking = SpinLock()
   private var stateIDValue: State = .stopped
   private(set) var stateID: State {
      get {
         return _stateAccessLock.synchronized {
            stateIDValue
         }
      } set {
         _stateAccessLock.synchronized {
            stateIDValue = newValue
         }
      }
   }

   init() {
      setupHandlers()
      log.initialize()
   }

   deinit {
      log.deinitialize()
   }
}

extension PlaybackEngine {

   func setFileToPlay(_ fileToPlay: AVAudioFile) {
      let change1 = Change(event: .setFile, oldState: stateID, newState: .updatingGraph)
      guard change1.shouldChange else {
         return
      }
      notifyAboutChange(change1)
      switch change1.oldState {
      case .updatingGraph, .stopped:
         break
      case .playing, .paused:
         context.stop()
      }
      let change2 = Change(event: .setFile, oldState: change1.newState, newState: .stopped)
      context.setFileToPlay(fileToPlay)
      notifyAboutChange(change2)
   }

   func stop() {
      let change = Change(event: .setFile, oldState: stateID, newState: .stopped)
      if change.shouldChange {
         switch change.oldState {
         case .paused, .playing:
            context.stop()
         case .updatingGraph, .stopped:
            break
         }
         notifyAboutChange(change)
      }
   }

   func pause() throws {
      let change = Change(event: .pause, oldState: stateID, newState: .paused)
      if change.shouldChange {
         switch change.oldState {
         case .paused, .stopped, .updatingGraph:
            break
         case .playing:
            context.pause()
         }
         notifyAboutChange(change)
      }
   }

   func resume() throws {
      let change = Change(event: .resume, oldState: stateID, newState: .playing)
      if change.shouldChange {
         switch change.oldState {
         case .updatingGraph, .stopped, .playing:
            break
         case .paused:
            try context.resume()
         }
         notifyAboutChange(change)
      }
   }

   func play() throws {
      let change = Change(event: .play, oldState: stateID, newState: .playing)
      if change.shouldChange {
         switch change.oldState {
         case .playing, .paused, .updatingGraph:
            break
         case .stopped:
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
      let change1 = Change(event: .setEffect, oldState: stateID, newState: .updatingGraph)
      guard change1.shouldChange else {
         return
      }
      notifyAboutChange(change1)
      switch change1.oldState {
      case .updatingGraph, .stopped:
         break
      case .paused, .playing:
         context.stopPlayer()
      }
      let change2 = Change(event: .setEffect, oldState: change1.newState, newState: change1.oldState)
      let restartCallback: () -> Void = { [weak self] in
         switch change2.newState {
         case .playing:
            do {
               try self?.context.startPlayer()
            } catch {
               log.error(.media, error)
            }
         case .paused:
            do {
               try self?.context.scheduleFile()
            } catch {
               log.error(.media, error)
            }
         case .stopped, .updatingGraph:
            break
         }
         self?.notifyAboutChange(change2)
      }
      DispatchQueue.userInitiated.async { [weak self] in
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
         let change = Change(event: .autostop, oldState: s.stateID, newState: .stopped)
         let message = "Playback stopped or file finished playing. Current state: \(change.oldState)"
         log.debug(.media, message)
         if change.oldState == .playing {
            DispatchQueue.main.async { [weak self] in guard let s = self else { return }
               s.context.stop()
               s.notifyAboutChange(change)
            }
         }
      }
   }

   private func notifyAboutChange(_ change: Change) {
      stateID = change.newState
      log.debug(.media, "State changed: \(change.oldState) => \(change.newState)")
      DispatchQueue.main.async {
         self.changeHandler?(change)
      }
   }
}
