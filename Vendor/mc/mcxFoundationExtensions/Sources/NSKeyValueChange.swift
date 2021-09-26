//
//  NSKeyValueChange.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.02.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSKeyValueChange: CustomStringConvertible {

   public var description: String {
      switch self {
      case .insertion:
         return "insertion"
      case .removal:
         return "removal"
      case .setting:
         return "setting"
      case .replacement:
         return "replacement"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
