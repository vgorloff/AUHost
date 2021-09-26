//
//  LayoutPriority.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
public typealias LayoutPriority = UILayoutPriority
#elseif os(OSX)
import AppKit
public typealias LayoutPriority = NSLayoutConstraint.Priority
#endif

extension LayoutPriority {

   public static func + (left: LayoutPriority, right: Float) -> LayoutPriority {
      return LayoutPriority(rawValue: left.rawValue + right)
   }

   public static func - (left: LayoutPriority, right: Float) -> LayoutPriority {
      return LayoutPriority(rawValue: left.rawValue - right)
   }
}
