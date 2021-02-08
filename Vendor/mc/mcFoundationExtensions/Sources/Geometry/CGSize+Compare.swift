//
//  CGSize+Compare.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

extension CGSize: Comparable {

   public static func < (lhs: CGSize, rhs: CGSize) -> Bool {
      return lhs.width < rhs.width || lhs.height < rhs.height
   }
}
