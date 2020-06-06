//
//  DateComponentsFormatter.UnitsStyle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension DateComponentsFormatter.UnitsStyle: CustomStringConvertible {

   public var description: String {
      switch self {
      case .abbreviated:
         return "abbreviated"
      case .brief:
         return "brief"
      case .full:
         return "full"
      case .positional:
         return "positional"
      case .short:
         return "short"
      case .spellOut:
         return "spellOut"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
