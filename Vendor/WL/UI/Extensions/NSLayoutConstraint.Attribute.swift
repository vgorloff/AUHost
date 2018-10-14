//
//  NSLayoutConstraint.Attribute.swift
//  mcmacOS-macOS
//
//  Created by Vlad Gorlov on 13.10.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
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
      }
   }
}
