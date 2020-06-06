//
//  UIBackgroundRefreshStatus.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 30.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import Foundation
import mcRuntime
import UIKit

extension UIBackgroundRefreshStatus: CustomStringConvertible {
   public var description: String {
      switch self {
      case .available:
         return "available"
      case .denied:
         return "denied"
      case .restricted:
         return "restricted"
      @unknown default:
         Assertion.unknown(self)
         return "unknown"
      }
   }
}
#endif
