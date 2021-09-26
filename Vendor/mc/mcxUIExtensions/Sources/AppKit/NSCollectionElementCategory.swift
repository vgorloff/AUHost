//
//  NSCollectionElementCategory.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit)
import AppKit

extension NSCollectionElementCategory: CustomStringConvertible {

   public var description: String {
      switch self {
      case .decorationView:
         return "decorationView"
      case .interItemGap:
         return "interItemGap"
      case .item:
         return "item"
      case .supplementaryView:
         return "supplementaryView"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
