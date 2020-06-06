//
//  NSGestureRecognizer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

extension NSGestureRecognizer {

   public typealias Handler = ((NSGestureRecognizer) -> Void)

   // MARK: -

   public convenience init(handler: Handler?) {
      self.init()
      setHandler(handler)
   }

   public convenience init<T: NSObject>(_ caller: T, handler: @escaping (T, NSGestureRecognizer) -> Void) {
      self.init()
      setHandler(caller, handler)
   }

   public convenience init<T: NSObject>(_ caller: T, handler: @escaping (T) -> Void) {
      self.init()
      setHandler(caller, handler)
   }

   // MARK: -

   public func setHandler(_ handler: Handler?) {
      target = self
      action = #selector(appHandleGesture(_:))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.gestureRecognizerHandler)
      }
   }

   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setHandler { [weak caller] _ in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T, NSGestureRecognizer) -> Void) {
      setHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller, $0)
      }
   }

   public func removeFromView() {
      view?.removeGestureRecognizer(self)
   }

   public func sendActions() {
      appHandleGesture(self)
   }

   // MARK: -

   fileprivate struct OBJCAssociationKeys {
      static var gestureRecognizerHandler = "app.ui.gestureRecognizerHandler"
   }

   @objc fileprivate func appHandleGesture(_ sender: NSGestureRecognizer) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &OBJCAssociationKeys.gestureRecognizerHandler) {
         handler(sender)
      }
   }
}
#endif
