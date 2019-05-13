//
//  MainToolbar.Event.swift
//  Shared
//
//  Created by Vlad Gorlov on 14.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import AppKit

extension MainToolbar {

   enum Event: Int {
      case reloadPlugIns
      case toggleMediaLibrary
   }
}

extension MainToolbar.Event {

   init?(id: NSToolbarItem.Identifier) {
      guard let event = (MainToolbar.Event.allValues.filter { $0.itemIdentifier == id }).first else {
         return nil
      }
      self = event
   }

   static var allValues: [MainToolbar.Event] {
      return [toggleMediaLibrary, reloadPlugIns]
   }

   static var toolbarIDs: [NSToolbarItem.Identifier] {
      return [toggleMediaLibrary, reloadPlugIns].map { $0.itemIdentifier }
   }

   var itemIdentifier: NSToolbarItem.Identifier {
      switch self {
      case .reloadPlugIns: return NSToolbarItem.Identifier("ua.com.wavalabs.toolbar.reloadPlugIns")
      case .toggleMediaLibrary: return NSToolbarItem.Identifier("ua.com.wavalabs.toolbar.toggleMediaLibrary")
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
      case .reloadPlugIns: return NSImage(named: NSImage.networkName)
      case .toggleMediaLibrary: return NSImage(named: NSImage.folderName)
      }
   }

   var paletteLabel: String {
      return label
   }
}
