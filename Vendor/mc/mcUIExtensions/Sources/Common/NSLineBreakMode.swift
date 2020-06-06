//
//  NSLineBreakMode.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#else
import UIKit
#endif
import mcRuntime

extension NSLineBreakMode: CustomStringConvertible {

   public var description: String {
      switch self {
      case .byCharWrapping:
         return "byCharWrapping"
      case .byClipping:
         return "byClipping"
      case .byWordWrapping:
         return "byWordWrapping"
      case .byTruncatingHead:
         return "byTruncatingHead"
      case .byTruncatingTail:
         return "byTruncatingTail"
      case .byTruncatingMiddle:
         return "byTruncatingMiddle"
      @unknown default:
         Assertion.failure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
