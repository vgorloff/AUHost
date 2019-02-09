//
//  NSMenu.swift
//  WLUI
//
//  Created by Vlad Gorlov on 15.10.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit

extension NSMenu {

   public func addItems(_ items: NSMenuItem...) {
      items.forEach { addItem($0) }
   }

   public func addItems(_ items: [NSMenuItem]) {
      items.forEach { addItem($0) }
   }

   @discardableResult
   public func addItem(title: String, keyEquivalent: String = "", modifiers: NSEvent.ModifierFlags? = nil, handler: NSMenuItem.Handler?) -> NSMenuItem {
      let item = NSMenuItem(title: title, keyEquivalent: keyEquivalent, handler: handler)
      if let modifiers = modifiers {
         item.keyEquivalentModifierMask = modifiers
      }
      addItem(item)
      return item
   }
}
