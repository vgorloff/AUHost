//
//  NSMenuItem.swift
//  WLUI
//
//  Created by Vlad Gorlov on 15.10.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit
import mcFoundation
import mcTypes

extension NSMenuItem {

   public typealias Handler = (() -> Void)

   public convenience init(title: String, keyEquivalent: String, handler: Handler?) {
      self.init(title: title, action: nil, keyEquivalent: keyEquivalent)
      setHandler(handler)
   }

   public convenience init(submenu: NSMenu) {
      self.init()
      self.submenu = submenu
   }

   public func setHandler(_ handler: Handler?) {
      target = self
      action = #selector(wavelabsActionHandler(_:))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.actionHandler)
      }
   }
}

extension NSMenuItem {

   private struct OBJCAssociationKeys {
      static var actionHandler = "com.wavelabs.actionHandler"
   }

   @objc private func wavelabsActionHandler(_ sender: NSControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &OBJCAssociationKeys.actionHandler) {
         handler()
      }
   }
}
