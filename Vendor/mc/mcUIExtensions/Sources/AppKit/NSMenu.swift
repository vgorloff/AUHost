//
//  NSMenu.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
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
#endif
