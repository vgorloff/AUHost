//
//  UIControl.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

extension UIControl {

   public typealias Handler = (() -> Void)

   public func setTouchUpInsideHandler(_ handler: Handler?) {
      addTarget(self, action: #selector(appUI_touchUpInside(_:)), for: .touchUpInside)
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.touchUpInside)
      }
   }

   public func setTouchUpInsideHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setTouchUpInsideHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   // For macOS compatibility.
   public func setHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setTouchUpInsideHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setValueChangedHandler(_ handler: Handler?) {
      addTarget(self, action: #selector(appUI_valueChanged(_:)), for: .valueChanged)
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.valueChanged)
      }
   }

   public func setValueChangedHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setValueChangedHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setEditingChangedHandler(_ handler: Handler?) {
      addTarget(self, action: #selector(appUI_editingChanged(_:)), for: .editingChanged)
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.editingChanged)
      }
   }

   public func setEditingChangedHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setEditingChangedHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setEditingDidBeginHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setEditingDidBeginHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setEditingDidBeginHandler(_ handler: Handler?) {
      addTarget(self, action: #selector(appUI_editingDidBegin(_:)), for: .editingDidBegin)
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.editingDidBegin)
      }
   }

   public func setEditingDidEndHandler<T: NSObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      setEditingDidEndHandler { [weak caller] in guard let caller = caller else { return }
         handler(caller)
      }
   }

   public func setEditingDidEndHandler(_ handler: Handler?) {
      addTarget(self, action: #selector(appUI_editingDidEnd(_:)), for: .editingDidEnd)
      if let handler = handler {
         ObjCAssociation.setCopyNonAtomic(value: handler, to: self, forKey: &Key.editingDidEnd)
      }
   }
}

extension UIControl {

   private struct Key {
      static var touchUpInside = "app.ui.touchUpInsideHandler"
      static var valueChanged = "app.ui.valueChangedHandler"
      static var editingChanged = "app.ui.editingChangedHandler"
      static var editingDidBegin = "app.ui.editingDidBeginHandler"
      static var editingDidEnd = "app.ui.editingDidEndHandler"
   }

   @objc private func appUI_touchUpInside(_ sender: UIControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.touchUpInside) {
         handler()
      }
   }

   @objc private func appUI_valueChanged(_ sender: UIControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.valueChanged) {
         handler()
      }
   }

   @objc private func appUI_editingChanged(_ sender: UIControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.editingChanged) {
         handler()
      }
   }

   @objc private func appUI_editingDidBegin(_ sender: UIControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.editingDidBegin) {
         handler()
      }
   }

   @objc private func appUI_editingDidEnd(_ sender: UIControl) {
      guard sender == self else {
         return
      }
      if let handler: Handler = ObjCAssociation.value(from: self, forKey: &Key.editingDidEnd) {
         handler()
      }
   }
}
#endif
