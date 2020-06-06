//
//  NSLayoutConstraint.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSLayoutConstraint {

   public func activate(priority: LayoutPriority? = nil) {
      if let priority = priority {
         self.priority = priority
      }
      isActive = true
   }

   public func activate(priority: Float) {
      activate(priority: LayoutPriority(rawValue: priority))
   }
}
