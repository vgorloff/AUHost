//
//  PadScreenDimension.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

public enum PadScreenDimension {

   /// iPad, iPad Mini, iPad Air
   case w1024h768

   /// iPad Pro 10.5"
   case w1112h834

   /// iPad Pro 12.9"
   case w1366h1024

   public var size: CGSize {
      switch self {
      case .w1024h768:
         return CGSize(width: 1024, height: 768)
      case .w1112h834:
         return CGSize(width: 1112, height: 834)
      case .w1366h1024:
         return CGSize(width: 1366, height: 1024)
      }
   }
}
