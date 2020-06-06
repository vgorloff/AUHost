//
//  NSMenuItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

extension NSMenuItem {

   public typealias Handler = (() -> Void)

   public convenience init(title: String, keyEquivalent: String, handler: Handler?) {
      self.init(title: title, action: nil, keyEquivalent: keyEquivalent)
      setHandler(handler)
   }

   public convenience init(title: String, tag: Int) {
      self.init()
      self.tag = tag
      self.title = title
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

   public func withTag(_ tag: Int) -> Self {
      self.tag = tag
      return self
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
#endif
