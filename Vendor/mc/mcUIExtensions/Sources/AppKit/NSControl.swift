//
//  NSControl.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

extension NSControl {

   public func setHandler(_ handler: (() -> Void)?) {
      target = self
      action = #selector(appActionHandler(_:))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.actionHandler)
      }
   }

   public func setHandler<T: AnyObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
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

extension Array where Element == NSControl {

   public func enable() {
      forEach { $0.isEnabled = true }
   }

   public func disable() {
      forEach { $0.isEnabled = false }
   }

   public func setEnabled(_ isEnabled: Bool) {
      forEach { $0.isEnabled = isEnabled }
   }
}
#endif
