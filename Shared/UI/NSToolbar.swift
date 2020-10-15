//
//  NSToolbar.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05/10/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa

extension NSToolbar {

   class GenericDelegate: NSObject, NSToolbarDelegate {

      var selectableItemIdentifiers = [String]()
      var defaultItemIdentifiers = [String]()
      var allowedItemIdentifiers = [String]()

      var eventHandler: ((Event) -> Void)?
      var makeItemCallback: ((_ itemIdentifier: String, _ willBeInserted: Bool) -> NSToolbarItem?)?

      func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
         return makeItemCallback?(itemIdentifier.rawValue, flag)
      }

      func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
         return defaultItemIdentifiers.map { NSToolbarItem.Identifier($0) }
      }

      func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
         return allowedItemIdentifiers.map { NSToolbarItem.Identifier($0) }
      }

      func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
         return selectableItemIdentifiers.map { NSToolbarItem.Identifier($0) }
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

}

extension NSToolbar.GenericDelegate {

   enum Event {
      case willAddItem(item: NSToolbarItem, index: Int)
      case didRemoveItem(item: NSToolbarItem)
   }
}
