//
//  NSAppearance.swift
//  mcAppKit-macOS
//
//  Created by Vlad Gorlov on 10.03.19.
//  Copyright © 2019 WaveLabs. All rights reserved.
//

#if os(OSX)
import AppKit

extension NSAppearance {

   @available(OSX 10.14, *)
   public var systemAppearance: SystemAppearance {
      let matches: [NSAppearance.Name] = [.aqua, .darkAqua, .accessibilityHighContrastAqua, .accessibilityHighContrastDarkAqua]
      if let name = bestMatch(from: matches), let value = SystemAppearance(name: name) {
         return value
      } else {
         assert(false)
         return .light
      }
   }
}
#endif
