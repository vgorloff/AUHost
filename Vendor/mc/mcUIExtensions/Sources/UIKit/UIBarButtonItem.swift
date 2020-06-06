//
//  UIBarButtonItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

extension UIBarButtonItem {

   public static func flexibleSpace() -> UIBarButtonItem {
      return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
   }

   public convenience init(systemItem: UIBarButtonItem.SystemItem) {
      self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
   }

   public convenience init(systemItem: UIBarButtonItem.SystemItem, handler: @escaping () -> Void) {
      self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
      setHandler(handler)
   }

   public convenience init(image: UIImage, style: UIBarButtonItem.Style = .plain) {
      self.init(image: image, style: style, target: nil, action: nil)
   }

   public convenience init(image: UIImage, style: UIBarButtonItem.Style = .plain, handler: (() -> Void)?) {
      self.init(image: image, style: style, target: nil, action: nil)
      setHandler(handler)
   }

   public convenience init(title: String, style: UIBarButtonItem.Style = .plain) {
      self.init(title: title, style: style, target: nil, action: nil)
   }

   public convenience init(title: String, style: UIBarButtonItem.Style = .plain, handler: (() -> Void)?) {
      self.init(title: title, style: style, target: nil, action: nil)
      setHandler(handler)
   }

   public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem) {
      self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
   }

   public convenience init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, handler: (() -> Void)?) {
      self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
      setHandler(handler)
   }
}

extension UIBarButtonItem {

   public typealias Handler = (() -> Void)

   public var handler: Handler? {
      return ObjCAssociation.value(from: self, forKey: &OBJCAssociationKeys.barButtonItemHandler)
   }

   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setHandler(_ handler: Handler?) {
      target = self
      action = #selector(UIBarButtonItem.appHandler(_:))
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &OBJCAssociationKeys.barButtonItemHandler)
      }
   }
}

extension UIBarButtonItem {

   fileprivate struct OBJCAssociationKeys {
      static var barButtonItemHandler = "app.ui.barButtonItemHandler"
   }

   @objc fileprivate func appHandler(_ sender: UIBarButtonItem) {
      guard sender == self else {
         return
      }
      handler?()
   }
}
#endif
