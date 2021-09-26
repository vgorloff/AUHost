//
//  NSControl.StateValue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSControl.StateValue: CustomStringConvertible {
   public var description: String {
      switch self {
      case .mixed:
         return "mixed"
      case .off:
         return "off"
      case .on:
         return "on"
      default:
         return "Unknown"
      }
   }
}
#endif
