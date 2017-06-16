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

   private weak var effectViewController: NSViewController? // Temporary store
   private weak var effectWindowController: EffectWindowController?

   private var canOpenEffectView: Bool {
      return effectWindowController == nil && viewModel.canOpenEffectView
   }
   private let segueOpenEffect = NSStoryboardSegue.Identifier("S:OpenEffectView")

   override func viewDidLoad() {
      super.viewDidLoad()
      setupHandlers()
      viewModel.model = model
      DispatchQueue.main.async { [weak self] in guard let s = self else { return }
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
         case .willSelectEffect:
            this.tablePresets.isEnabled = false
         case .didSelectEffect(let error):
            this.tablePresets.reloadData()
            this.tablePresets.isEnabled = this.viewModel.availablePresets.count > 0
            if error == nil {
               if this.effectWindowController != nil {
                  DispatchQueue.main.async { [weak self] in
                     self?.actionToggleEffectView(nil)
                  }
               }
            }
         case .playbackEngineStageChanged(let state):
            switch state {
            case .Playing:
               this.buttonPlay.isEnabled = true
               this.buttonPlay.title = "Pause"
               this.buttonOpenEffectView.isEnabled = this.canOpenEffectView
            case .Stopped:
               this.buttonPlay.isEnabled = true
               this.buttonPlay.title = "Play"
               this.buttonOpenEffectView.isEnabled = this.canOpenEffectView
            case .Paused:
               this.buttonPlay.isEnabled = true
               this.buttonPlay.title = "Resume"
               this.buttonOpenEffectView.isEnabled = this.canOpenEffectView
            case .SettingEffect, .SettingFile:
               this.buttonPlay.isEnabled = false
               this.buttonOpenEffectView.isEnabled = false
            }
         }
      }
      model.eventHandler = { [weak self] in guard let this = self else { return }
         switch $0 {
         case .audioComponentChanged(let change):
            switch change {
            case .audioComponentRegistered:
               break
            case .audioComponentInstanceInvalidated:
               this.viewModel.selectEffect(nil)
            }
         }
      }
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

   @IBAction private func actionTogglePlayAudio(_ sender: AnyObject) {
      viewModel.togglePlay()
   }

   @IBAction private func actionToggleEffectView(_ sender: AnyObject?) {
      guard canOpenEffectView else {
         return
      }
      let engine = Application.sharedInstance.playbackEngine
      engine.openEffectView { [weak self] controller in guard let s = self else { return }
         s.effectViewController = controller
         if controller != nil {
            s.performSegue(withIdentifier: s.segueOpenEffect, sender: s)
         }
      }
   }

}

extension MainViewController {

   private func processFileAtURL(_ url: URL) {
      do {
         defer {
            url.stopAccessingSecurityScopedResource() // Seems working fine without this line
         }
         _ = url.startAccessingSecurityScopedResource() // Seems working fine without this line
         mediaItemView.mediaFileURL = url
         try viewModel.processFileAtURL(url)
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
         return viewModel.availablePresets.count + 1
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
         let preset = viewModel.availablePresets[row - 1]
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

      switch tableView {
      case tableEffects:
         effectWindowController?.close()
         if tableView.selectedRow == 0 {
            Logger.debug(subsystem: .controller, category: .handle, message: "Clearing effect")
            viewModel.selectEffect(nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < viewModel.availableEffects.count {
               let component = viewModel.availableEffects[row]
               Logger.debug(subsystem: .controller, category: .handle, message: "Selecting effect: \"\(component.name)\"")
               viewModel.selectEffect(component)
            }
         }
      case tablePresets:
         if tableView.selectedRow == 0 {
            Logger.debug(subsystem: .controller, category: .lifecycle, message: "Clearing preset")
            viewModel.selectPreset(nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < viewModel.availablePresets.count {
               let preset = viewModel.availablePresets[row]
               Logger.debug(subsystem: .controller, category: .lifecycle, message: "Selecting preset: \"\(preset.name)\"")
               viewModel.selectPreset(preset)
            }
         }
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }

}
