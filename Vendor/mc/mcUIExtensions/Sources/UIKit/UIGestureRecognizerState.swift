//
//  UIGestureRecognizerState.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcRuntime
import UIKit

extension UIGestureRecognizer.State: CustomDebugStringConvertible {
   public var debugDescription: String {
      switch self {
      case .began:
         return "Began"
      case .cancelled:
         return "Cancelled"
      case .possible:
         return "Possible"
      case .failed:
         return "Failed"
      case .changed:
         return "Changed"
      case .ended:
         return "Ended"
      @unknown default:
         Assertion.unknown(self)
         return "Unknown"
      }
   }
}
#endif
