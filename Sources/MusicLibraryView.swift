//
//  MusicLibraryView.swift
//  AUHost
//
//  Created by Vlad Gorlov on 05.04.20.
//  Copyright © 2020 WaveLabs. All rights reserved.
//

import AppKit
import mcxUIReusable
import mcxRuntime
import mcxUI

private let log = Logger.getLogger(MusicLibraryView.self)

class MusicLibraryView: ScrollView {
   
   private var library = MusicLibrary()
   
   private lazy var clipView = NSClipView()
   private lazy var tableView = NSTableView()
   private lazy var tableColumn = NSTableColumn()
   
   var onSelected: ((MusicLibraryItem) -> Void)?
   
   override func setupUI() {
      clipView.documentView = tableView
      clipView.autoresizingMask = [.width, .height]
      
      contentView = clipView
      
      autohidesScrollers = true
      
      tableView.allowsExpansionToolTips = true
      tableView.allowsMultipleSelection = false
      tableView.autosaveTableColumns = false
      tableView.backgroundColor = .controlBackgroundColor
      tableView.gridColor = .gridColor
      tableView.intercellSpacing = CGSize(width: 3, height: 2)
      tableView.setContentHuggingPriority(.defaultHigh, for: .vertical)
      tableView.usesAlternatingRowBackgroundColors = true
      tableView.addTableColumn(tableColumn)
      if #available(OSX 11.0, *) {
         tableView.style = .fullWidth
      }
      tableView.rowHeight = 24
      if #available(macOS 10.13, *) {
         tableView.usesAutomaticRowHeights = true
      }
      
      tableColumn.title = "Songs"
      tableColumn.isEditable = false
   }
   
   override func setupHandlers() {
      tableView.delegate = self
      tableView.dataSource = self
   }
}


extension MusicLibraryView: NSTableViewDelegate, NSTableViewDataSource {
   
   func numberOfRows(in tableView: NSTableView) -> Int {
      return library.items.count
   }
   
   func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let label = NSTextField().autolayoutView()
      label.isBezeled = false
      label.isEditable = false
      label.drawsBackground = false
      let component = library.items[row]
      label.stringValue = component.fullName

      let view = View()
      view.addSubview(label)
      anchor.withFormat("|-3-[*]-3-|", label).activate()
      anchor.withFormat("V:|-2-[*]-2-|", label).activate()
      return view
   }
   
   func tableViewSelectionDidChange(_ aNotification: Notification) {
      guard tableView.selectedRow >= 0 else {
         return
      }
      let component = library.items[tableView.selectedRow]
      log.verbose(component.fullName)
      onSelected?(component)
   }
}
