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
import mcUIReusable
import mcUI
import mcRuntime

private let log = Logger.getLogger(MainViewController.self)

// Links: [Developer Forums: MLMediaLibrary in Mavericks not working?](https://devforums.apple.com/message/1125821#1125821)
class MainViewController: ViewController {

   private lazy var mediaItemView = MediaItemView().autolayoutView()
   private lazy var effectsTableColumn = NSTableColumn()
   private lazy var tableEffects = NSTableView()
   private lazy var clipView1 = NSClipView()
   private lazy var scrollView1 = NSScrollView()
   private lazy var presetsTableColumn = NSTableColumn()
   private lazy var tablePresets = NSTableView()
   private lazy var clipView2 = NSClipView()
   private lazy var scrollView2 = NSScrollView()
   private lazy var contentStackView = NSStackView().autolayoutView()
   private lazy var mainStackView = StackView(axis: .vertical).autolayoutView()
   private lazy var libraryView = MusicLibraryView()

   let viewModel = MainViewUIModel()

   override func viewDidAppear() {
      super.viewDidAppear()
      viewModel.reloadEffects()
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

   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let label = NSTextField()
      label.isBezeled = false
      label.isEditable = false
      label.drawsBackground = false
      switch tableView {
      case tableEffects:
         if row == 0 {
            label.stringValue = "- No Effect -"
         } else {
            let component = viewModel.availableEffects[row - 1]
            label.stringValue = component.name
         }
         return label
      case tablePresets:
         if row == 0 {
            label.stringValue = "- Default Preset -"
         } else {
            let preset = viewModel.availablePresets[row - 1]
            label.stringValue = preset.name
         }
         return label
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
         viewModel.closeEffectView()
         if tableView.selectedRow == 0 {
            log.debug("Clearing effect")
            viewModel.selectEffect(nil, completion: nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < viewModel.availableEffects.count {
               let component = viewModel.availableEffects[row]
               log.debug("Selecting effect: \"\(component.name)\"")
               viewModel.selectEffect(component) { [weak self] _ in
                  DispatchQueue.main.async {
                     self?.toggleEffect()
                  }
               }
            }
         }
      case tablePresets:
         if tableView.selectedRow == 0 {
            log.debug("Clearing preset")
            viewModel.selectPreset(nil)
         } else {
            let row = tableView.selectedRow - 1
            if row < viewModel.availablePresets.count {
               let preset = viewModel.availablePresets[row]
               log.debug("Selecting preset: \"\(preset.name)\"")
               viewModel.selectPreset(preset)
            }
         }
      default:
         fatalError("Unknown tableView: \(tableView)")
      }
   }
}

extension MainViewController {

   override func setupHandlers() {
      tableEffects.delegate = self
      tableEffects.dataSource = self

      tablePresets.delegate = self
      tablePresets.dataSource = self
      mediaItemView.onCompleteDragWithObjects = { [weak self] in
         self?.viewModel.handlePastboard($0)
      }
      libraryView.onSelected = { [weak self] item in
         self?.viewModel.processFileAtURL(item.url)
      }
   }

   func toggleEffect() {
      if viewModel.canOpenEffectView == true {
         viewModel.openEffectView { [weak self] in
            let wc = EffectWindowController()
            wc.contentViewController = $0
            wc.eventHandler = {
               switch $0 {
               case .windowWillClose:
                  self?.viewModel.effectWindowWillClose()
               }
            }
            wc.showWindow(nil)
            self?.viewModel.effectWindowWillOpen(wc)
         }
      }
   }
   
   func toggleSongs() {
      libraryView.isHidden = !libraryView.isHidden
   }

   func handleEvent(_ event: MainViewUIModel.Event, _ state: MainViewUIModel.State) {
      switch event {
      case .loadingEffects(let isBusy):
         if !isBusy {
            tableEffects.reloadData()
         }
         tableEffects.isEnabled = !isBusy
      case .willSelectEffect:
         tablePresets.isEnabled = false
      case .didSelectEffect:
         tablePresets.reloadData()
         tablePresets.isEnabled = viewModel.availablePresets.count > 0
      case .didClearEffect:
         tablePresets.reloadData()
         tablePresets.isEnabled = viewModel.availablePresets.count > 0
      case .audioComponentsChanged:
         tablePresets.reloadData()
      case .selectMedia(let url):
         mediaItemView.mediaFileURL = url
      default:
         break
      }
   }
}

extension MainViewController {

   override func setupUI() {

      view.addSubview(mainStackView)

      mainStackView.addArrangedSubviews(mediaItemView, contentStackView, libraryView)
      mainStackView.distribution = .fill
      mainStackView.spacing = 0

      contentStackView.addArrangedSubviews(scrollView1, scrollView2)
      contentStackView.alignment = .top
      contentStackView.distribution = .fillEqually

      scrollView2.autohidesScrollers = true
      scrollView2.horizontalLineScroll = 19
      scrollView2.horizontalPageScroll = 10
      scrollView2.translatesAutoresizingMaskIntoConstraints = false
      scrollView2.usesPredominantAxisScrolling = false
      scrollView2.verticalLineScroll = 19
      scrollView2.verticalPageScroll = 10

      clipView2.documentView = tablePresets
      clipView2.autoresizingMask = [.width, .height]

      tablePresets.addTableColumn(presetsTableColumn)

      tablePresets.allowsExpansionToolTips = true
      tablePresets.allowsMultipleSelection = false
      tablePresets.autosaveTableColumns = false
      tablePresets.backgroundColor = .controlBackgroundColor
      tablePresets.gridColor = .gridColor
      tablePresets.intercellSpacing = CGSize(width: 3, height: 2)
      tablePresets.isEnabled = false
      tablePresets.setContentHuggingPriority(.defaultHigh, for: .vertical)
      tablePresets.usesAlternatingRowBackgroundColors = true
      if #available(OSX 11.0, *) {
         tablePresets.style = .fullWidth
      }
      tablePresets.rowHeight = 24
      tablePresets.usesAutomaticRowHeights = true

      presetsTableColumn.title = "Presets"
      presetsTableColumn.isEditable = false

      scrollView2.contentView = clipView2

      scrollView1.autohidesScrollers = true
      scrollView1.horizontalLineScroll = 19
      scrollView1.horizontalPageScroll = 10
      scrollView1.translatesAutoresizingMaskIntoConstraints = false
      scrollView1.usesPredominantAxisScrolling = false
      scrollView1.verticalLineScroll = 19
      scrollView1.verticalPageScroll = 10

      clipView1.documentView = tableEffects
      clipView1.autoresizingMask = [.width, .height]

      tableEffects.addTableColumn(effectsTableColumn)

      tableEffects.allowsExpansionToolTips = true
      tableEffects.allowsMultipleSelection = false
      tableEffects.autosaveTableColumns = false
      tableEffects.backgroundColor = .controlBackgroundColor
      tableEffects.gridColor = .gridColor
      tableEffects.intercellSpacing = CGSize(width: 3, height: 2)
      tableEffects.setContentHuggingPriority(.defaultHigh, for: .vertical)
      tableEffects.usesAlternatingRowBackgroundColors = true
      if #available(OSX 11.0, *) {
         tableEffects.style = .fullWidth
      }
      tableEffects.rowHeight = 24
      tableEffects.usesAutomaticRowHeights = true

      effectsTableColumn.title = "Effects"
      effectsTableColumn.isEditable = false

      scrollView1.contentView = clipView1
   }

   override func setupLayout() {

      anchor.pin.toBounds(mainStackView).activate()
      var constraints: [NSLayoutConstraint] = []

      constraints += [contentStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
                      contentStackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 320)]

      mediaItemView.heightAnchor.constraint(equalToConstant: 98).activate()
      constraints.activate()
      
      libraryView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor, multiplier: 1 / 1.5).activate()
   }
}
