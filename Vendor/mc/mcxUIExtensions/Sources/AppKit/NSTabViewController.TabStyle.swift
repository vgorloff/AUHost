//
//  NSTabViewController.TabStyle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import Foundation

extension NSTabViewController.TabStyle: CustomStringConvertible {

   public var description: String {
      switch self {
      case .toolbar:
         return "toolbar"
      case .segmentedControlOnBottom:
         return "segmentedControlOnBottom"
      case .segmentedControlOnTop:
         return "segmentedControlOnTop"
      case .unspecified:
         return "unspecified"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
