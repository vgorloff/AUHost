//
//  NSToolbar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#if os(OSX)
import Cocoa

extension NSToolbar {

   class GenericDelegate: NSObject, NSToolbarDelegate {

      var selectableItemIdentifiers: [NSToolbarItem.Identifier] = []
      var defaultItemIdentifiers: [NSToolbarItem.Identifier] = []
      var allowedItemIdentifiers: [NSToolbarItem.Identifier] = []

      var eventHandler: ((Event) -> Void)?
      var makeItemCallback: ((_ itemIdentifier: NSToolbarItem.Identifier, _ willBeInserted: Bool) -> NSToolbarItem?)?
   }
}

extension NSToolbar.GenericDelegate {

   enum Event {
      case willAddItem(item: NSToolbarItem, index: Int)
      case didRemoveItem(item: NSToolbarItem)
   }
}

extension NSToolbar.GenericDelegate {

   func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
      return makeItemCallback?(itemIdentifier, flag)
   }

   func toolbarDefaultItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
      return defaultItemIdentifiers
   }

   func toolbarAllowedItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
      return allowedItemIdentifiers
   }

   func toolbarSelectableItemIdentifiers(_: NSToolbar) -> [NSToolbarItem.Identifier] {
      return selectableItemIdentifiers
   }

   // MARK: Notifications

   func toolbarWillAddItem(_ notification: Notification) {
      if let toolbarItem = notification.userInfo?["item"] as? NSToolbarItem,
         let index = notification.userInfo?["newIndex"] as? Int {
         eventHandler?(.willAddItem(item: toolbarItem, index: index))
      }
   }

   func toolbarDidRemoveItem(_ notification: Notification) {
      if let toolbarItem = notification.userInfo?["item"] as? NSToolbarItem {
         eventHandler?(.didRemoveItem(item: toolbarItem))
      }
   }
}
#endif
