//
//  MainViewController.swift
//  AUHost
//
//  Created by Vlad Gorlov on 21.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import AVFoundation
import Cocoa
import CoreAudioKit
import MediaLibrary

// Links: [Developer Forums: MLMediaLibrary in Mavericks not working?](https://devforums.apple.com/message/1125821#1125821)
class MainViewController: NSViewController {

   @IBOutlet private weak var buttonOpenEffectView: NSButton!
   @IBOutlet private weak var buttonPlay: NSButton!
   @IBOutlet private weak var tableEffects: NSTableView!
   @IBOutlet private weak var tablePresets: NSTableView!
   @IBOutlet private weak var mediaItemView: MediaItemView!

   var uiModel: MainViewUIModel? {
      willSet {
         uiModel?.uiDelegate = nil
      }
      didSet {
         uiModel?.uiDelegate = self
         uiModel?.reloadEffects()
      }
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      setupHandlers()
   }
}

extension MainViewController: EffectWindowCoordination {

   func handleEvent(_ event: EffectWindowController.CoordinationEvent) {
      switch event {
      case .windowWillClose:
         uiModel?.effectWindowWillClose()
      }
   }
}

extension MainViewController {

   func setupHandlers() {
      mediaItemView.onCompleteDragWithObjects = { [weak self] in
         self?.uiModel?.handlePastboard($0)
      }
   }

   @IBAction private func actionTogglePlayAudio(_: AnyObject) {
      uiModel?.togglePlay()
   }

   @IBAction private func actionToggleEffectView(_: AnyObject?) {
      if uiModel?.canOpenEffectView == true {
         uiModel?.openEffectView { [weak self] in
            let wc = EffectWindowController()
            wc.contentViewController = $0
            wc.coordinationDelegate = self
            wc.showWindow(nil)
            self?.uiModel?.effectWindowWillOpen(wc)
         }
      }
   }
}

extension MainViewController: MainViewUIHandling {

   func handleEvent(_ event: MainViewUIModel.UIEvent) {
      guard let uiModel = uiModel else { return }
      switch event {
      case .effectWindowWillOpen:
         buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
      case .effectWindowWillClose:
         buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
      case .loadingEffects(let isBusy):
         if !isBusy {
            tableEffects.reloadData()
         }
         tableEffects.isEnabled = !isBusy
         buttonOpenEffectView.isEnabled = !isBusy && uiModel.canOpenEffectView
      case .willSelectEffect:
         tablePresets.isEnabled = false
      case .didSelectEffect:
         tablePresets.reloadData()
         tablePresets.isEnabled = uiModel.availablePresets.count > 0
         buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
      case .didClearEffect:
         tablePresets.reloadData()
         tablePresets.isEnabled = uiModel.availablePresets.count > 0
         buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
      case .playbackEngineStageChanged(let state):
         switch state {
         case .playing:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Pause"
            buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
         case .stopped:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Play"
            buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
         case .paused:
            buttonPlay.isEnabled = true
            buttonPlay.title = "Resume"
            buttonOpenEffectView.isEnabled = uiModel.canOpenEffectView
         case .updatingGraph:
            buttonPlay.isEnabled = false
            buttonOpenEffectView.isEnabled = false
         }
      case .audioComponentsChanged:
         tablePresets.reloadData()
      case .selectMedia(let url):
         mediaItemView.mediaFileURL = url
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
            log.debug(.controller, "Clearing effect")
            uiModel.selectEffect(nil, completion: nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < uiModel.availableEffects.count {
               let component = uiModel.availableEffects[row]
               log.debug(.controller, "Selecting effect: \"\(component.name)\"")
               uiModel.selectEffect(component) { [weak self] _ in
                  DispatchQueue.main.async {
                     self?.actionToggleEffectView(nil)
                  }
               }
            }
         }
      case tablePresets:
         if tableView.selectedRow == 0 {
            log.debug(.controller, "Clearing preset")
            uiModel.selectPreset(nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < uiModel.availablePresets.count {
               let preset = uiModel.availablePresets[row]
               log.debug(.controller, "Selecting preset: \"\(preset.name)\"")
               uiModel.selectPreset(preset)
            }
         }
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }
}
