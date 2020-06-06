//
//  NSTextField.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSTextField {

   public var title: String {
      get {
         return stringValue
      } set {
         stringValue = newValue
      }
   }

   public var text: String {
      get {
         return stringValue
      } set {
         stringValue = newValue
      }
   }
}
#endif
