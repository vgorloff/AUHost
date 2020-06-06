//
//  UIUserInterfaceSizeClass.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcRuntime
import UIKit

extension UIUserInterfaceSizeClass: CustomStringConvertible {

   public var description: String {
      switch self {
      case .compact:
         return "compact"
      case .regular:
         return "regular"
      case .unspecified:
         return "unspecified"
      @unknown default:
         Assertion.unknown(self)
         return "Unknown"
      }
   }
}
#endif
