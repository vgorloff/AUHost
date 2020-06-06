//
//  PhoneScreenDimension.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

public enum PhoneScreenDimension {

   /// iPhone 5, 5s, 5c, SE
   case w320h568

   /// iPhone 6, 6s, 7, 8
   case w375h667

   /// iPhone X, Xs
   case w375h812

   /// iPhone 6+, 6s+, 7+, 8+
   case w414h736

   /// iPhone Xr, Xs Max
   case w414h896

   public var size: CGSize {
      switch self {
      case .w320h568:
         return CGSize(width: 320, height: 568)
      case .w375h667:
         return CGSize(width: 375, height: 667)
      case .w375h812:
         return CGSize(width: 375, height: 812)
      case .w414h736:
         return CGSize(width: 414, height: 736)
      case .w414h896:
         return CGSize(width: 414, height: 896)
      }
   }
}
