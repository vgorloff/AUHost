//
//  SystemAppearance.swift
//  mcApp-macOSTests
//
//  Created by Vlad Gorlov on 09.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

@objc public enum SystemAppearance: Int {

   case light, highContrastLight
   case dark, highContrastDark

   public var isDark: Bool {
      switch self {
      case .dark, .highContrastDark:
         return true
      case .light, .highContrastLight:
         return false
      }
   }

   public var isHighContrast: Bool {
      switch self {
      case .highContrastLight, .highContrastDark:
         return true
      case .light, .dark:
         return false
      }
   }
}
