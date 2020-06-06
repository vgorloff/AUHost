//
//  UIAlertController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIAlertController {

   public convenience init(alertWithTitle title: String, message: String) {
      self.init(title: title, message: message, preferredStyle: .alert)
   }

   public convenience init(alertWithTitle title: String) {
      self.init(title: title, message: nil, preferredStyle: .alert)
   }

   public convenience init(alertWithMessage message: String) {
      // `title` needs to be empty string instead of `nil`. Otherwize `message` will be treated as `title`.
      self.init(title: "", message: message, preferredStyle: .alert)
   }
}

extension UIAlertController {

   public convenience init(actionSheetWithTitle title: String) {
      self.init(title: title, message: nil, preferredStyle: .actionSheet)
   }
}

extension UIAlertController {

   private typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

   public func tapAlertButton(atIndex index: Int, animated: Bool = true) {
      guard let action = actions.element(at: index) else {
         return
      }
      if let block = action.value(forKey: "handler") {
         let blockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(block as AnyObject).toOpaque())
         let handler = unsafeBitCast(blockPtr, to: AlertHandler.self)
         presentingViewController?.dismiss(animated: animated) {
            handler(action)
         }
      } else {
         log.error(.view, "Unable to retrieve handler for alert action at index \(index)")
      }
   }
}
#endif
