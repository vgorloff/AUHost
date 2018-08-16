//
//  MainViewUIModel.swift
//  AUHost
//
//  Created by Vlad Gorlov on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AVFoundation
import AppKit
import Foundation
import mcBase

class MainViewUIModel {

   enum Event {
      case loadingEffects(Bool)
      case willSelectEffect
      case didSelectEffect(Error?)
      case didClearEffect
      case playbackEngineStageChanged(PlaybackEngine.State)
      case audioComponentsChanged
      case selectMedia(URL)
      case effectWindowWillOpen
      case effectWindowWillClose
   }

   var eventHandler: ((Event) -> Void)?

   private var isEffectOpened = false
   private(set) var selectedAUComponent: AVAudioUnitComponent?
   private(set) var availableEffects: [AVAudioUnitComponent] = []
   private(set) var availablePresets: [AUAudioUnitPreset] = []
   private(set) lazy var audioUnitDatasource = AudioComponentsUtility()
   private(set) lazy var mediaLibraryLoader = MediaLibraryUtility()
   private(set) lazy var playbackEngine = PlaybackEngine()
   private var effectWindowController: NSWindowController? // Temporary store

   init() {
      setupHandlers()
   }
}

extension MainViewUIModel {

   var canOpenEffectView: Bool {
      guard !isEffectOpened, let component = selectedAUComponent else {
         return false
      }
      let flags = AudioComponentFlags(rawValue: component.audioComponentDescription.componentFlags)
      let v3AU = flags.contains(AudioComponentFlags.isV3AudioUnit)
      return component.hasCustomView || v3AU
   }

   func reloadEffects() {
      eventHandler?(.loadingEffects(true))
      audioUnitDatasource.updateEffectList { [weak self] in guard let this = self else { return }
         this.availableEffects = $0
         this.eventHandler?(.loadingEffects(false))
      }
   }

   func selectEffect(_ component: AVAudioUnitComponent?, completion: Completion<AVAudioUnit>?) {
      eventHandler?(.willSelectEffect)
      playbackEngine.selectEffect(componentDescription: component?.audioComponentDescription) { [weak self] in
         guard let this = self else { return }
         switch $0 {
         case .effectCleared:
            this.availablePresets.removeAll()
            this.selectedAUComponent = nil
            this.eventHandler?(.didClearEffect)
         case .failure(let e):
            log.error(.controller, e)
            this.eventHandler?(.didSelectEffect(e))
         case .success(let effect):
            this.availablePresets = effect.auAudioUnit.factoryPresets ?? []
            this.selectedAUComponent = component
            this.eventHandler?(.didSelectEffect(nil))
            completion?(effect)
         }
      }
   }

   func selectPreset(_ preset: AUAudioUnitPreset?) {
      playbackEngine.selectPreset(preset: preset)
   }

   func togglePlay() {
      do {
         switch playbackEngine.stateID {
         case .playing:
            try playbackEngine.pause()
         case .paused:
            try playbackEngine.resume()
         case .stopped:
            try playbackEngine.play()
         case .updatingGraph:
            break
         }
      } catch {
         log.error(.controller, error)
      }
   }

   func processFileAtURL(_ url: URL) {
      do {
         defer {
            url.stopAccessingSecurityScopedResource() // Seems working fine without this line
         }
         _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
         eventHandler?(.selectMedia(url))
         let f = try AVAudioFile(forReading: url)
         playbackEngine.setFileToPlay(f)
         if playbackEngine.stateID == .stopped {
            try playbackEngine.play()
         }
         log.debug(.controller, "File assigned: \(url.absoluteString)")
      } catch {
         log.error(.controller, error)
      }
   }

   func openEffectView(completion: Completion<NSViewController>?) {
      isEffectOpened = true
      playbackEngine.openEffectView { [weak self] in
         if let vc = $0 {
            completion?(vc)
         } else {
            self?.isEffectOpened = false
         }
      }
   }

   func closeEffectView() {
      effectWindowController?.close()
      effectWindowWillClose()
   }

   func effectWindowWillOpen(_ vc: NSWindowController) {
      isEffectOpened = true
      effectWindowController = vc
      eventHandler?(.effectWindowWillOpen)
   }

   func effectWindowWillClose() {
      isEffectOpened = false
      effectWindowController = nil
      eventHandler?(.effectWindowWillClose)
   }

   func handlePastboard(_ objects: MediaObjectPasteboardUtility.PasteboardObjects) {
      switch objects {
      case .none:
         break
      case .mediaObjects(let mediaObjectsDict):
         let mediaObjects = mediaLibraryLoader.mediaObjectsFromPlist(pasteboardPlist: mediaObjectsDict)
         if let firstMediaObject = mediaObjects.first?.1.first?.1, let url = firstMediaObject.url {
            processFileAtURL(url)
         }
      case .filePaths(let filePaths):
         if let firstFilePath = filePaths.first {
            let url = NSURL(fileURLWithPath: firstFilePath)
            processFileAtURL(url as URL)
         }
      }
   }
}


extension MainViewUIModel {

   private func setupHandlers() {
      playbackEngine.changeHandler = { [weak self] in
         self?.eventHandler?(.playbackEngineStageChanged($0.newState))
      }
      audioUnitDatasource.handlerStateChange = { [weak self] change in guard let this = self else { return }
         switch change {
         case .audioComponentRegistered:
            this.eventHandler?(.audioComponentsChanged)
         case .audioComponentInstanceInvalidated(let au, _):
            if au.component == this.selectedAUComponent?.audioComponent {
               this.selectEffect(nil, completion: nil)
            } else {
               this.eventHandler?(.audioComponentsChanged)
            }
         }
      }
   }
}
