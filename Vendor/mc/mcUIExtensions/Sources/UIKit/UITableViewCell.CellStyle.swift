//
//  UITableViewCell.CellStyle.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcRuntime
import UIKit

extension UITableViewCell.CellStyle {

   public var stringValue: String {
      switch self {
      case .default:
         return "default"
      case .subtitle:
         return "subtitle"
      case .value1:
         return "value1"
      case .value2:
         return "value2"
      @unknown default:
         Assertion.unknown(self)
         return "unknown"
      }
   }
}
#endif
