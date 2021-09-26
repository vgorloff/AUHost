//
//  UIApplication.State.swift
//  mcUIExtensions_iOS
//
//  Created by Vlad Gorlov on 23.09.21.
//

#if canImport(UIKit)
import UIKit
import mcxRuntime

extension UIApplication.State: CustomStringConvertible {

   public var description: String {
      switch self {
      case .active:
         return "active"
      case .inactive:
         return "inactive"
      case .background:
         return "background"
      @unknown default:
         Assertion.unknown(self)
         return "unknown"
      }
   }
}

#endif
