//
//  UIAlertController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcUI
import UIKit

extension UIAlertController {

   public func addDefaultAction(_ title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let action = AlertAction(defaultActionWithTitle: title, tag: tag, handler: handler)
      addAction(action)
   }

   public func addDestructiveAction(_ title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let action = AlertAction(destructiveActionWithTitle: title, tag: tag, handler: handler)
      addAction(action)
   }

   public func addCancelAction(_ title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      let action = AlertAction(cancelActionWithTitle: title, tag: tag, handler: handler)
      addAction(action)
   }
}

#endif
