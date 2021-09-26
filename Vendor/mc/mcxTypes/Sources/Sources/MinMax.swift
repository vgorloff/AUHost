//
//  MinMax.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06/05/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

public struct MinMax<T: Comparable> {

   public var min: T
   public var max: T

   public init(min aMin: T, max aMax: T) {
      min = aMin
      max = aMax
      assert(min <= max)
   }

   public init(valueA: MinMax, valueB: MinMax) {
      min = Swift.min(valueA.min, valueB.min)
      max = Swift.max(valueA.max, valueB.max)
   }
}

extension MinMax where T: Numeric {
   public var difference: T {
      return max - min
   }
}

extension MinMax where T: FloatingPoint {
   public var difference: T {
      return max - min
   }
}
