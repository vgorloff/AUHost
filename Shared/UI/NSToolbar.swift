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

      enum Event {
         case willAddItem(item: NSToolbarItem, index: Int)
         case didRemoveItem(item: NSToolbarItem)
      }

      var eventHandler: ((Event) -> Void)?
      var makeItemCallback: ((_ itemIdentifier: String, _ willBeInserted: Bool) -> NSToolbarItem?)?

      func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: String,
                   willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
         return makeItemCallback?(itemIdentifier, flag)
      }

      func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
         return defaultItemIdentifiers
      }

      func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
         return allowedItemIdentifiers
      }

      func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [String] {
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

}
