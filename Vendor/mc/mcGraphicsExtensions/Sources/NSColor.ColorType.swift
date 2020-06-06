//
//  NSColor.ColorType.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcRuntime

extension NSColor.ColorType: CustomStringConvertible {

   public static let allTypes: [NSColor.ColorType] = [.catalog, .componentBased, .pattern]

   public var description: String {
      switch self {
      case .catalog:
         return "catalog"
      case .componentBased:
         return "componentBased"
      case .pattern:
         return "pattern"
      @unknown default:
         Assertion.unknown(self)
         return "Unknown"
      }
   }
}
#endif
