//
//  UIGestureRecognizer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

extension UIGestureRecognizer {

   public typealias Handler = ((UIGestureRecognizer) -> Void)

   public func setHandler(_ handler: Handler?) {
      addTarget(self, action: #selector(appHandleGesture(_:)))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.gestureRecognizerHandler)
      }
   }

   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setHandler { [weak caller] _ in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T, UIGestureRecognizer) -> Void) {
      setHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller, $0)
      }
   }

   public convenience init(handler: UIGestureRecognizer.Handler?) {
      self.init()
      setHandler(handler)
   }

   public convenience init<T: NSObject>(_ caller: T, handler: @escaping (T, UIGestureRecognizer) -> Void) {
      self.init()
      setHandler(caller, handler)
   }

   public convenience init<T: NSObject>(_ caller: T, handler: @escaping (T) -> Void) {
      self.init()
      setHandler(caller, handler)
   }
}

extension UIGestureRecognizer {

   public func removeFromView() {
      view?.removeGestureRecognizer(self)
   }

   public func sendActions() {
      appHandleGesture(self)
   }

   public func relativeLocation(in view: UIView) -> CGPoint {
      let absoluteLocation = location(in: view)
      let relativeLocation = CGPoint(x: absoluteLocation.x / view.bounds.width, y: absoluteLocation.y / view.bounds.height)
      return relativeLocation
   }
}

extension UIGestureRecognizer {

   fileprivate struct OBJCAssociationKeys {
      static var gestureRecognizerHandler = "app.ui.gestureRecognizerHandler"
   }

   @objc fileprivate func appHandleGesture(_ sender: UIGestureRecognizer) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &OBJCAssociationKeys.gestureRecognizerHandler) {
         handler(sender)
      }
   }
}
#endif
