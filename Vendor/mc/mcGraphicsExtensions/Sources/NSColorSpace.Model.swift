//
//  NSColorSpace.Model.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcRuntime

extension NSColorSpace.Model: CustomStringConvertible {

   public static let allModels: [NSColorSpace.Model] = [unknown, gray, rgb, cmyk, lab, deviceN, indexed, patterned]

   public var description: String {
      switch self {
      case .cmyk:
         return "cmyk"
      case .deviceN:
         return "deviceN"
      case .gray:
         return "gray"
      case .indexed:
         return "indexed"
      case .lab:
         return "lab"
      case .patterned:
         return "patterned"
      case .rgb:
         return "rgb"
      case .unknown:
         return "unknown"
      @unknown default:
         Assertion.unknown(self)
         return "Unknown"
      }
   }
}
#endif
