//
//  UIModalPresentationStyle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcRuntime
import UIKit

extension UIModalPresentationStyle: CustomStringConvertible {

   public var description: String {
      switch self {
      case .currentContext:
         return "currentContext"
      case .custom:
         return "custom"
      case .formSheet:
         return "formSheet"
      case .fullScreen:
         return "fullScreen"
      case .none:
         return "none"
      case .overCurrentContext:
         return "overCurrentContext"
      case .overFullScreen:
         return "overFullScreen"
      case .pageSheet:
         return "pageSheet"
      case .popover:
         return "popover"
      case .blurOverFullScreen:
         return "blurOverFullScreen"
      case .automatic:
         return "automatic"
      @unknown default:
         Assertion.unknown(self)
         return "Unknown"
      }
   }
}
#endif
