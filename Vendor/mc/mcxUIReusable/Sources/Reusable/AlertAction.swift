//
//  AlertAction.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.06.18.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

public class AlertAction: UIAlertAction {

   public var tag: Int?

   public convenience init(defaultActionWithTitle title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      self.init(title: title, style: .default, handler: handler)
      self.tag = tag
   }

   public convenience init(cancelActionWithTitle title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      self.init(title: title, style: .cancel, handler: handler)
      self.tag = tag
   }

   public convenience init(destructiveActionWithTitle title: String, tag: Int? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
      self.init(title: title, style: .destructive, handler: handler)
      self.tag = tag
   }
}
#endif
