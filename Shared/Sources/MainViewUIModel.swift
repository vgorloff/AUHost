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

protocol MainViewUIHandling: class {
   func handleEvent(_: MainViewUIModel.UIEvent)
}

class MainViewUIModel {

   enum UIEvent {
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

   weak var uiDelegate: MainViewUIHandling?

   private var isEffectOpened = false
   private(set) var selectedAUComponent: AVAudioUnitComponent?
   private(set) var availableEffects = [AVAudioUnitComponent]()
   private(set) var availablePresets = [AUAudioUnitPreset]()
   private let audioUnitDatasource = AudioComponentsUtility()
   let mediaLibraryLoader = MediaLibraryUtility()
   private let playbackEngine = PlaybackEngine()
   private var effectWindowController: NSWindowController? // Temporary store

   init() {
      playbackEngine.changeHandler = { [weak self] in
         self?.uiDelegate?.handleEvent(.playbackEngineStageChanged($0.newState))
      }
      audioUnitDatasource.handlerStateChange = { [weak self] change in guard let this = self else { return }
         switch change {
         case .audioComponentRegistered:
            this.uiDelegate?.handleEvent(.audioComponentsChanged)
         case .audioComponentInstanceInvalidated(let au, _):
            if au.component == this.selectedAUComponent?.audioComponent {
               this.selectEffect(nil, completion: nil)
            } else {
               this.uiDelegate?.handleEvent(.audioComponentsChanged)
            }
         }
      }
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
      uiDelegate?.handleEvent(.loadingEffects(true))
      audioUnitDatasource.updateEffectList { [weak self] in guard let this = self else { return }
         this.availableEffects = $0
         this.uiDelegate?.handleEvent(.loadingEffects(false))
      }
   }

   func selectEffect(_ component: AVAudioUnitComponent?, completion: Completion<AVAudioUnit>?) {
      uiDelegate?.handleEvent(.willSelectEffect)
      playbackEngine.selectEffect(componentDescription: component?.audioComponentDescription) { [weak self] in
         guard let this = self else { return }
         switch $0 {
         case .effectCleared:
            this.availablePresets.removeAll()
            this.selectedAUComponent = nil
            this.uiDelegate?.handleEvent(.didClearEffect)
         case .failure(let e):
            Log.error(subsystem: .controller, category: .event, error: e)
            this.uiDelegate?.handleEvent(.didSelectEffect(e))
         case .success(let effect):
            this.availablePresets = effect.auAudioUnit.factoryPresets ?? []
            this.selectedAUComponent = component
            this.uiDelegate?.handleEvent(.didSelectEffect(nil))
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
         Log.error(subsystem: .controller, category: .event, error: error)
      }
   }

   func processFileAtURL(_ url: URL) {
      do {
         defer {
            url.stopAccessingSecurityScopedResource() // Seems working fine without this line
         }
         _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
         uiDelegate?.handleEvent(.selectMedia(url))
         let f = try AVAudioFile(forReading: url)
         playbackEngine.setFileToPlay(f)
         if playbackEngine.stateID == .stopped {
            try playbackEngine.play()
         }
         Log.debug(subsystem: .controller, category: .access, message: "File assigned: \(url.absoluteString)")
      } catch {
         Log.error(subsystem: .controller, category: .access, error: error)
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
      uiDelegate?.handleEvent(.effectWindowWillOpen)
   }

   func effectWindowWillClose() {
      isEffectOpened = false
      effectWindowController = nil
      uiDelegate?.handleEvent(.effectWindowWillClose)
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
