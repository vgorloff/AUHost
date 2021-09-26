//
//  FloatingPoint.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.11.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension FloatingPoint {

   public var degreesToRadians: Self {
      return self * .pi / 180
   }

   public var radiansToDegrees: Self {
      return self * 180 / .pi
   }
}

extension FloatingPoint {

   public func trimmed(to range: ClosedRange<Self>) -> Self {
      if self < range.lowerBound {
         return range.lowerBound
      }
      if self > range.upperBound {
         return range.upperBound
      }
      return self
   }
}
