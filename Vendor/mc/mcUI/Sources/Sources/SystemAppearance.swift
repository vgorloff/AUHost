//
//  SystemAppearance.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

@objc public enum SystemAppearance: Int, CaseIterable, CustomStringConvertible {

   case light, highContrastLight
   case dark, highContrastDark

   #if os(OSX)
   @available(OSX 10.14, *)
   public init?(name: NSAppearance.Name) {
      if let value = SystemAppearance.allCases.first(where: { $0.name == name }) {
         self = value
      } else {
         return nil
      }
   }
   #endif

   public init?(serializedValue: String) {
      if let value = SystemAppearance.allCases.first(where: { $0.serializedValue == serializedValue }) {
         self = value
      } else {
         return nil
      }
   }

   // MARK: -

   public var isDark: Bool {
      switch self {
      case .dark, .highContrastDark:
         return true
      case .light, .highContrastLight:
         return false
      }
   }

   public var isLight: Bool {
      return !isDark
   }

   public var isHighContrast: Bool {
      switch self {
      case .highContrastLight, .highContrastDark:
         return true
      case .light, .dark:
         return false
      }
   }

   public var description: String {
      return serializedValue
   }

   public var serializedValue: String {
      switch self {
      case .dark:
         return "dark"
      case .light:
         return "light"
      case .highContrastDark:
         return "highContrastDark"
      case .highContrastLight:
         return "highContrastLight"
      }
   }

   #if os(OSX)
   @available(OSX 10.14, *)
   public var name: NSAppearance.Name {
      switch self {
      case .dark:
         return .darkAqua
      case .light:
         return .aqua
      case .highContrastDark:
         return .accessibilityHighContrastDarkAqua
      case .highContrastLight:
         return .accessibilityHighContrastAqua
      }
   }

   @available(OSX 10.14, *)
   public var appearance: NSAppearance? {
      return NSAppearance(named: name)
   }
   #endif
}
