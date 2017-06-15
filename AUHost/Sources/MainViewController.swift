//
//  ViewController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 21.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import AVFoundation
import MediaLibrary
import CoreAudioKit

/**
 Links:
 * [Developer Forums: MLMediaLibrary in Mavericks not working?](https://devforums.apple.com/message/1125821#1125821)
 */
class MainViewController: NSViewController {

   @IBOutlet private weak var buttonOpenEffectView: NSButton!
   @IBOutlet private weak var buttonPlay: NSButton!
   @IBOutlet private weak var tableEffects: NSTableView!
   @IBOutlet private weak var tablePresets: NSTableView!
   @IBOutlet private weak var mediaItemView: MediaItemView!

   let viewModel = MainViewModel()
   let model = MainModel()

   private var availablePresets = [AUAudioUnitPreset]()
   private weak var effectViewController: NSViewController? // Temporary store
   private weak var effectWindowController: EffectWindowController?
   private var playbackEngine: PlaybackEngine {
      return Application.sharedInstance.playbackEngine
   }
   private var selectedAUComponent: AVAudioUnitComponent?
   private var canOpenEffectView: Bool {
      guard let component = selectedAUComponent, effectWindowController == nil else {
         return false
      }
      let flags = AudioComponentFlags(rawValue: component.audioComponentDescription.componentFlags)
      let v3AU = flags.contains(AudioComponentFlags.isV3AudioUnit)
      return component.hasCustomView || v3AU
   }
   private let segueOpenEffect = NSStoryboardSegue.Identifier("S:OpenEffectView")

   override func viewDidLoad() {
      super.viewDidLoad()
      setupHandlers()
      viewModel.model = model
      DispatchQueue.main.async { [weak self] in guard let s = self else { return }
         s.setUpPlaybackHelper()
         s.setUpMediaItemView()
         s.viewModel.reloadEffects()
      }
   }

   override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
      if let segueID = segue.identifier, let ctrl = segue.destinationController as? EffectWindowController,
         segueID == segueOpenEffect {
         ctrl.contentViewController = effectViewController
         effectWindowController = ctrl
         effectViewController = nil
         buttonOpenEffectView.isEnabled = false
         ctrl.handlerWindowWillClose = { [weak self] in guard let s = self else { return }
            s.effectWindowController?.contentViewController = nil
            s.effectWindowController = nil
            s.buttonOpenEffectView.isEnabled = s.canOpenEffectView
         }
      }
   }

}

extension MainViewController {

   private func setupHandlers() {
      viewModel.viewHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .loadingEffects(let isBusy):
            if !isBusy {
               this.tableEffects.reloadData()
            }
            this.tableEffects.isEnabled = !isBusy
         }
      }
      model.eventHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .audioComponentChanged(let change):
            switch change {
            case .audioComponentRegistered:
               break
            case .audioComponentInstanceInvalidated:
               this.playbackEngine.selectEffect(component: nil, completionHandler: nil)
               this.selectedAUComponent = nil
            }
            this.viewModel.reloadEffects()
         }
      }
   }

   @IBAction private func actionTogglePlayAudio(_ sender: AnyObject) {
      do {
         switch playbackEngine.stateID {
         case .Playing:
            playbackEngine.pause()
         case .Paused:
            try playbackEngine.resume()
         case .Stopped:
            try playbackEngine.play()
         case .SettingEffect, .SettingFile: break
         }
      } catch {
         Logger.error(subsystem: .controller, category: .handle, message: error)
      }
   }

   @IBAction private func actionToggleEffectView(_ sender: AnyObject?) {
      guard canOpenEffectView && effectWindowController == nil else {
         return
      }
      playbackEngine.openEffectView { [weak self] controller in guard let s = self else { return }
         s.effectViewController = controller
         if controller != nil {
            s.performSegue(withIdentifier: s.segueOpenEffect, sender: s)
         }
      }
   }

}

extension MainViewController {

   private func setUpMediaItemView() {
      mediaItemView.onCompleteDragWithObjects = { [weak self] results in
         guard let s = self else { return }
         switch results {
         case .none:
            break
         case .mediaObjects(let mediaObjectsDict):
            let mediaObjects = Application.sharedInstance.mediaLibraryLoader.mediaObjectsFromPlist(
               pasteboardPlist: mediaObjectsDict)
            if let firstMediaObject = mediaObjects.first?.1.first?.1, let url = firstMediaObject.url {
               s.processFileAtURL(url)
            }
         case .filePaths(let filePaths):
            if let firstFilePath = filePaths.first {
               let url = NSURL(fileURLWithPath: firstFilePath)
               s.processFileAtURL(url as URL)
            }
         }
      }
   }

   private func setUpPlaybackHelper() {
      playbackEngine.changeHandler = { [weak self, weak playbackEngine] change in
         guard let s = self, let engine = playbackEngine else { return }
         switch change {
         case .EngineStateChanged(_, _):
            switch engine.stateID {
            case .Playing:
               s.buttonPlay.isEnabled = true
               s.buttonPlay.title = "Pause"
               s.buttonOpenEffectView.isEnabled = s.canOpenEffectView
            case .Stopped:
               s.buttonPlay.isEnabled = true
               s.buttonPlay.title = "Play"
               s.buttonOpenEffectView.isEnabled = s.canOpenEffectView
            case .Paused:
               s.buttonPlay.isEnabled = true
               s.buttonPlay.title = "Resume"
               s.buttonOpenEffectView.isEnabled = s.canOpenEffectView
            case .SettingEffect, .SettingFile:
               s.buttonPlay.isEnabled = false
               s.buttonOpenEffectView.isEnabled = false
            }
         }
      }
   }

   private func processFileAtURL(_ url: URL) {
      do {
         defer {
            url.stopAccessingSecurityScopedResource() // Seems working fine without this line
         }
         _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
         let f = try AVAudioFile(forReading: url)
         mediaItemView.mediaFileURL = url
         try playbackEngine.setFileToPlay(f)
         if playbackEngine.stateID == .Stopped {
            try playbackEngine.play()
         }
         Logger.debug(subsystem: .controller, category: .open, message: "File assigned: \(url.absoluteString)")
      } catch {
         Logger.error(subsystem: .controller, category: .open, message: error)
      }
   }

}

extension MainViewController: NSTableViewDataSource {

   func numberOfRows(in tableView: NSTableView) -> Int {
      switch tableView {
      case tableEffects:
         return viewModel.availableEffects.count + 1
      case tablePresets:
         return availablePresets.count + 1
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }

   func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
      switch tableView {
      case tableEffects:
         if row == 0 {
            return "- No Effect -"
         }
         let component = viewModel.availableEffects[row - 1]
         return component.name
      case tablePresets:
         if row == 0 {
            return "- Default Preset -"
         }
         let preset = availablePresets[row - 1]
         return preset.name
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }
}

extension MainViewController: NSTableViewDelegate {

   func tableViewSelectionDidChange(_ aNotification: Notification) {
      guard let tableView = aNotification.object as? NSTableView, tableView.selectedRow >= 0 else {
         return
      }
      func handleTableEffects() {
         let shouldReopenEffectView = (effectWindowController != nil)
         effectWindowController?.close()
         if tableView.selectedRow == 0 {
            Logger.debug(subsystem: .controller, category: .handle, message: "Clearing effect")
            playbackEngine.selectEffect(component: nil) { [weak self] _ in
               guard let s = self else { return }
               s.availablePresets.removeAll()
               s.tablePresets.reloadData()
               s.tablePresets.isEnabled = s.availablePresets.count > 0
            }
            selectedAUComponent = nil
         } else {
            let row = tableView.selectedRow - 1
            if row < viewModel.availableEffects.count {
               let component = viewModel.availableEffects[row]
               Logger.debug(subsystem: .controller, category: .handle, message: "Selecting effect: \"\(component.name)\"")
               playbackEngine.selectEffect(component: component) { [weak self, weak component] result in
                  guard let s = self else { return }
                  switch result {
                  case .EffectCleared: break
                  case .Failure(let e):
                     Logger.error(subsystem: .controller, category: .handle, message: e)
                  case .Success(let effect):
                     s.availablePresets = effect.auAudioUnit.factoryPresets ?? []
                     s.tablePresets.reloadData()
                     s.tablePresets.isEnabled = s.availablePresets.count > 0
                     s.selectedAUComponent = component
                     if shouldReopenEffectView {
                        DispatchQueue.main.async { [weak self] in
                           self?.actionToggleEffectView(nil)
                        }
                     }
                  }
               }
            }
         }
      }

      func handleTablePresets() {
         if tableView.selectedRow == 0 {
            Logger.debug(subsystem: .controller, category: .lifecycle, message: "Clearing preset")
            playbackEngine.selectPreset(preset: nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < availablePresets.count {
               let preset = availablePresets[row]
               Logger.debug(subsystem: .controller, category: .lifecycle, message: "Selecting preset: \"\(preset.name)\"")
               playbackEngine.selectPreset(preset: preset)
            }
         }
      }

      switch tableView {
      case tableEffects:
         handleTableEffects()
      case tablePresets:
         handleTablePresets()
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }

}
