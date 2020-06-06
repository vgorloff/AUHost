//
//  NSToolbarItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

extension NSToolbarItem {

   public typealias Handler = (() -> Void)

   public func setHandler(_ handler: Handler?) {
      target = self
      action = #selector(wavelabsActionHandler(_:))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.actionHandler)
      }
   }
}

extension NSToolbarItem {

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
