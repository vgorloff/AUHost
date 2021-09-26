//
//  NSLayoutConstraint.Attribute.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSLayoutConstraint.Attribute: CustomStringConvertible {

   public var description: String {
      switch self {
      case .bottom:
         return "bottom"
      case .left:
         return "left"
      case .right:
         return "right"
      case .top:
         return "top"
      case .leading:
         return "leading"
      case .trailing:
         return "trailing"
      case .width:
         return "width"
      case .height:
         return "height"
      case .centerX:
         return "centerX"
      case .centerY:
         return "centerY"
      case .lastBaseline:
         return "lastBaseline"
      case .firstBaseline:
         return "firstBaseline"
      case .notAnAttribute:
         return "notAnAttribute"
      #if os(iOS) || os(tvOS)
      case .leftMargin:
         return "leftMargin"
      case .rightMargin:
         return "rightMargin"
      case .topMargin:
         return "topMargin"
      case .bottomMargin:
         return "bottomMargin"
      case .leadingMargin:
         return "leadingMargin"
      case .trailingMargin:
         return "trailingMargin"
      case .centerXWithinMargins:
         return "centerXWithinMargins"
      case .centerYWithinMargins:
         return "centerYWithinMargins"
      #endif
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
