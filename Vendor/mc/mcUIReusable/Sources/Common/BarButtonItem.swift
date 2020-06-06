//
//  BarButtonItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import mcUI

#if os(macOS)
open class BarButtonItem {

   class BarButtonItemView: View {}

   public typealias Handler = (() -> Void)

   public var title: String? {
      get {
         return button.title.isEmpty ? nil : button.title
      } set {
         button.title = newValue ?? ""
      }
   }

   private lazy var button = Button()

   public var isEnabled: Bool {
      get {
         return button.isEnabled
      } set {
         button.isEnabled = newValue
      }
   }

   let view = BarButtonItemView()

   public init(title: String) {
      button.title = title
      view.addSubview(button)
      LayoutConstraint().pin.toBounds(button).activate()
   }

   public convenience init(title: String, handler: (() -> Void)?) {
      self.init(title: title)
      setHandler(handler)
   }

   public init(customView: NSView) {
      view.addSubview(customView)
      LayoutConstraint().pin.toBounds(customView).activate()
   }

   public func setHandler(_ handler: Handler?) {
      button.setHandler(handler)
   }

   public func setHandler<T: AnyObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      button.setHandler(caller, handler)
   }
}
#else
public class BarButtonItem: UIBarButtonItem {
}
#endif
