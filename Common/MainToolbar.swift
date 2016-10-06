//
//  MainToolbar.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

class MainToolbar: NSToolbar {

   let toolbarDelegate = GenericDelegate()

   enum Event {
      case reloadPlugIns
      case toggleMediaLibrary
   }

   var eventHandler: ((Event) -> Void)?

   init(identifier: String, showsReloadPlugInsItem: Bool = true) {
      super.init(identifier: identifier)
      allowsUserCustomization = true
      autosavesConfiguration = true
      displayMode = .iconAndLabel
      toolbarDelegate.allowedItemIdentifiers = [NSToolbarSpaceItemIdentifier, NSToolbarFlexibleSpaceItemIdentifier]
      toolbarDelegate.defaultItemIdentifiers = Event.toolbarIDs + [NSToolbarFlexibleSpaceItemIdentifier]
      if showsReloadPlugInsItem == false {
         toolbarDelegate.defaultItemIdentifiers = toolbarDelegate.defaultItemIdentifiers.filter {
            $0 != Event.reloadPlugIns.itemIdentifier
         }
      }
      toolbarDelegate.selectableItemIdentifiers = toolbarDelegate.allowedItemIdentifiers
      toolbarDelegate.makeItemCallback = { [unowned self] id, flag in
         guard let event = Event(stringValue: id) else {
            return nil
         }
         return self.makeToolbarItem(event: event)
      }
      delegate = toolbarDelegate
   }

   private func makeToolbarItem(event: Event) -> NSToolbarItem {
      let item = NSToolbarItem(itemIdentifier: event.itemIdentifier)
      item.target = self
      item.action = #selector(handle(toolbarItem:))
      item.label = event.label
      item.paletteLabel = event.paletteLabel
      if event.image != nil {
         item.image = event.image
      } else if event.view != nil {
         item.view = event.view
      }
      return item
   }

   @objc private func handle(toolbarItem: NSToolbarItem) {
      guard let event = Event(stringValue: toolbarItem.itemIdentifier) else {
         return
      }
      eventHandler?(event)
   }
}

extension MainToolbar.Event {

   var itemIdentifier: String {
      switch self {
      case .reloadPlugIns: return "ua.com.wavalabs.toolbar.reloadPlugIns"
      case .toggleMediaLibrary: return "ua.com.wavalabs.toolbar.toggleMediaLibrary"
      }
   }

   var label: String {
      switch self {
      case .reloadPlugIns: return "Reload PlugIns"
      case .toggleMediaLibrary: return "Media Library"
      }
   }

   var view: NSView? {
      return nil
   }

   var image: NSImage? {
      switch self {
      case .reloadPlugIns: return NSImage(named: NSImageNameNetwork)
      case .toggleMediaLibrary: return NSImage(named: NSImageNameFolder)
      }
   }

   var paletteLabel: String {
      return label;
   }

   static var allValues: [MainToolbar.Event] {
      return [toggleMediaLibrary, reloadPlugIns]
   }

   static var toolbarIDs: [String] {
      return [toggleMediaLibrary, reloadPlugIns].map { $0.itemIdentifier }
   }

   init?(stringValue: String) {
      guard let event = (MainToolbar.Event.allValues.filter { $0.itemIdentifier == stringValue }).first else {
         return nil
      }
      self = event
   }
}
