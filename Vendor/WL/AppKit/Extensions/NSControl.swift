//
//  NSControl.swift
//  WLUI
//
//  Created by Vlad Gorlov on 12.08.17.
//  Copyright © 2017 Demo. All rights reserved.
//

import AppKit
import mcFoundation
import mcTypes

extension NSControl {

   public func setHandler(_ handler: (() -> Void)?) {
      target = self
      action = #selector(appActionHandler(_:))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.actionHandler)
      }
   }

   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }
}

extension NSControl {

   private struct OBJCAssociationKeys {
      static var actionHandler = "app.ui.actionHandler"
   }

   @objc private func appActionHandler(_ sender: NSControl) {
      guard sender == self else {
         return
      }
      if let handler: (() -> Void) = ObjCAssociation.value(from: self, forKey: &OBJCAssociationKeys.actionHandler) {
         handler()
      }
   }
}
