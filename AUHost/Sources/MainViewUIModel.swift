//
//  MainViewModel.swift
//  AUHost
//
//  Created by VG (DE) on 15.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation
import AVFoundation
import AppKit

protocol MainViewUIModelType: class {
   var viewHandler: ((MainViewUIModel.ViewEvent) -> Void)? { get set }
   var canOpenEffectView: Bool { get }
   var availableEffects: [AVAudioUnitComponent] { get }
   var availablePresets: [AUAudioUnitPreset] { get }
   func reloadEffects()
   func selectEffect(_ component: AVAudioUnitComponent?)
   func selectPreset(_ preset: AUAudioUnitPreset?)
   func processFileAtURL(_ url: URL)
   func openEffectView()
   func closeEffectView()
   func handlePastboard(_ objects: MediaObjectPasteboardUtility.PasteboardObjects)
   func togglePlay()
   func prepare(segue: NSStoryboardSegue)
}

class MainViewUIModel {

   enum ViewEvent {
      case loadingEffects(Bool)
      case willSelectEffect
      case didSelectEffect(Error?)
      case playbackEngineStageChanged(PlaybackEngineStateMachine.State)
      case audioComponentsChanged
      case selectMedia(URL)
      case effectWindowWillOpen
      case effectWindowWillClose
   }

   enum CoordinatorEvent {
      case openEffectView(NSViewController)
      case closeEffectView
      case prepare(NSStoryboardSegue)
   }

   var viewHandler: ((ViewEvent) -> Void)?
   var coordinatorHandler: ((CoordinatorEvent) -> Void)?

   private var isEffectOpened = false
   private(set) var selectedAUComponent: AVAudioUnitComponent?
   private(set) var availableEffects = [AVAudioUnitComponent]()
   private(set) var availablePresets = [AUAudioUnitPreset]()
   let audioUnitDatasource = AudioComponentsUtility()
   let mediaLibraryLoader = MediaLibraryUtility()
   let playbackEngine = PlaybackEngine()

   init() {
      playbackEngine.changeHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .EngineStateChanged(_, let new):
            this.viewHandler?(.playbackEngineStageChanged(new))
         }
      }
      audioUnitDatasource.handlerStateChange = { [weak self] change in guard let this = self else { return }
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

   func effectWindowWillOpen() {
      isEffectOpened = true
      viewHandler?(.effectWindowWillOpen)
   }

   func effectWindowWillClose() {
      isEffectOpened = false
      viewHandler?(.effectWindowWillClose)
   }

}

extension MainViewUIModel: MainViewUIModelType {

   func prepare(segue: NSStoryboardSegue) {
      coordinatorHandler?(.prepare(segue))
   }

   var canOpenEffectView: Bool {
      guard !isEffectOpened, let component = selectedAUComponent else {
         return false
      }
      let flags = AudioComponentFlags(rawValue: component.audioComponentDescription.componentFlags)
      let v3AU = flags.contains(AudioComponentFlags.isV3AudioUnit)
      return component.hasCustomView || v3AU
   }

   func reloadEffects() {
      viewHandler?(.loadingEffects(true))
      audioUnitDatasource.updateEffectList { [weak self] in guard let this = self else { return }
         this.availableEffects = $0
         this.viewHandler?(.loadingEffects(false))
      }

   }

   func selectEffect(_ component: AVAudioUnitComponent?) {
      viewHandler?(.willSelectEffect)
      playbackEngine.selectEffect(component: component) { [weak self, weak component] in guard let this = self else { return }
         switch $0 {
         case .EffectCleared:
            this.availablePresets.removeAll()
            this.selectedAUComponent = nil
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
      playbackEngine.selectPreset(preset: preset)
   }

   func togglePlay() {
      do {
         switch playbackEngine.stateID {
         case .Playing:
            playbackEngine.pause()
         case .Paused:
            try playbackEngine.resume()
         case .Stopped:
            try playbackEngine.play()
         case .SettingEffect, .SettingFile:
            break
         }
      } catch {
         Logger.error(subsystem: .controller, category: .handle, message: error)
      }
   }

   func processFileAtURL(_ url: URL) {
      do {
         defer {
            url.stopAccessingSecurityScopedResource() // Seems working fine without this line
         }
         _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
         viewHandler?(.selectMedia(url))
         let f = try AVAudioFile(forReading: url)
         try playbackEngine.setFileToPlay(f)
         if playbackEngine.stateID == .Stopped {
            try playbackEngine.play()
         }
         Logger.debug(subsystem: .controller, category: .open, message: "File assigned: \(url.absoluteString)")
      } catch {
         Logger.error(subsystem: .controller, category: .open, message: error)
      }
   }

   func openEffectView() {
      playbackEngine.openEffectView { [weak self] in guard let this = self else { return }
         if let vc = $0 {
            this.coordinatorHandler?(.openEffectView(vc))
         }
      }
   }

   func closeEffectView() {
      coordinatorHandler?(.closeEffectView)
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
