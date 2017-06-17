//
//  MainViewController.swift
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

   var uiModel: MainViewUIModelType? {
      didSet {
         setupHandlers()
         uiModel?.reloadEffects()
      }
   }

   private weak var effectViewController: NSViewController? // Temporary store

   override func viewDidLoad() {
      super.viewDidLoad()
   }

   override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
      uiModel?.prepare(segue: segue)
   }

}

extension MainViewController {

   private func setupHandlers() {
      uiModel?.viewHandler = { [weak self] in guard let this = self, let uiModel = self?.uiModel else { return }
         switch $0 {
         case .effectWindowWillOpen:
            this.buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
         case .effectWindowWillClose:
            this.buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
         case .loadingEffects(let isBusy):
            if !isBusy {
               this.tableEffects.reloadData()
            }
            this.tableEffects.isEnabled = !isBusy
            this.buttonOpenEffectView.isEnabled = !isBusy && uiModel.canOpenEffectView
         case .willSelectEffect:
            this.tablePresets.isEnabled = false
         case .didSelectEffect(let error):
            this.tablePresets.reloadData()
            this.tablePresets.isEnabled = uiModel.availablePresets.count > 0
            if error == nil {
               DispatchQueue.main.async {
                  self?.actionToggleEffectView(nil)
               }
            }
            this.buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
         case .playbackEngineStageChanged(let state):
            switch state {
            case .Playing:
               this.buttonPlay.isEnabled = true
               this.buttonPlay.title = "Pause"
               this.buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
            case .Stopped:
               this.buttonPlay.isEnabled = true
               this.buttonPlay.title = "Play"
               this.buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
            case .Paused:
               this.buttonPlay.isEnabled = true
               this.buttonPlay.title = "Resume"
               this.buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
            case .SettingEffect, .SettingFile:
               this.buttonPlay.isEnabled = false
               this.buttonOpenEffectView.isEnabled = false
            }
         case .audioComponentsChanged:
            this.tablePresets.reloadData()
         case .selectMedia(let url):
            this.mediaItemView.mediaFileURL = url
         }
      }
      mediaItemView.onCompleteDragWithObjects = { [weak self] in
         self?.uiModel?.handlePastboard($0)
      }
   }

   @IBAction private func actionTogglePlayAudio(_ sender: AnyObject) {
      uiModel?.togglePlay()
   }

   @IBAction private func actionToggleEffectView(_ sender: AnyObject?) {
      if uiModel?.canOpenEffectView == true {
         uiModel?.openEffectView()
      }
   }

}

extension MainViewController: NSTableViewDataSource {

   func numberOfRows(in tableView: NSTableView) -> Int {
      switch tableView {
      case tableEffects:
         return (uiModel?.availableEffects.count ?? 0) + 1
      case tablePresets:
         return (uiModel?.availablePresets.count ?? 0) + 1
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
         let component = uiModel?.availableEffects[row - 1]
         return component?.name ?? "- Unknown -"
      case tablePresets:
         if row == 0 {
            return "- Default Preset -"
         }
         let preset = uiModel?.availablePresets[row - 1]
         return preset?.name ?? "- Unknown -"
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }
}

extension MainViewController: NSTableViewDelegate {

   func tableViewSelectionDidChange(_ aNotification: Notification) {
      guard let tableView = aNotification.object as? NSTableView, tableView.selectedRow >= 0, let uiModel = uiModel else {
         return
      }

      switch tableView {
      case tableEffects:
         uiModel.closeEffectView()
         if tableView.selectedRow == 0 {
            Logger.debug(subsystem: .controller, category: .handle, message: "Clearing effect")
            uiModel.selectEffect(nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < uiModel.availableEffects.count {
               let component = uiModel.availableEffects[row]
               Logger.debug(subsystem: .controller, category: .handle, message: "Selecting effect: \"\(component.name)\"")
               uiModel.selectEffect(component)
            }
         }
      case tablePresets:
         if tableView.selectedRow == 0 {
            Logger.debug(subsystem: .controller, category: .lifecycle, message: "Clearing preset")
            uiModel.selectPreset(nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < uiModel.availablePresets.count {
               let preset = uiModel.availablePresets[row]
               Logger.debug(subsystem: .controller, category: .lifecycle, message: "Selecting preset: \"\(preset.name)\"")
               uiModel.selectPreset(preset)
            }
         }
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }

}
