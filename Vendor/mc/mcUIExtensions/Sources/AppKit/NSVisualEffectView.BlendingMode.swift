//
//  NSVisualEffectView.BlendingMode.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSVisualEffectView.BlendingMode: CustomStringConvertible {

   public var description: String {
      switch self {
      case .behindWindow:
         return "behindWindow"
      case .withinWindow:
         return "withinWindow"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
