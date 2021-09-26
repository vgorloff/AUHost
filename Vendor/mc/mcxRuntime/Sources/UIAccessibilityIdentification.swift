//
//  UIAccessibilityIdentification.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import UIKit

extension UIAccessibilityIdentification {

   public var accessibilityKey: AccessibilityKey {
      get {
         if let value = accessibilityIdentifier {
            return value
         } else {
            assertionFailure()
            return ""
         }
      } set {
         accessibilityIdentifier = newValue.accessibilityKey
      }
   }
}

#endif
