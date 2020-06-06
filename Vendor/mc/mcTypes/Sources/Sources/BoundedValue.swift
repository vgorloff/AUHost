//
//  BoundedValue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

public protocol BoundedValueType {
   static func - (lhs: Self, rhs: Self) -> Self
   static func + (lhs: Self, rhs: Self) -> Self
   static func * (lhs: Self, rhs: Double) -> Self
   var doubleValue: Double { get }
}

extension Double: BoundedValueType {
   public var doubleValue: Double {
      return self
   }
}

public struct BoundedValue<T: Comparable> where T: BoundedValueType {
   public private(set) var min: T
   public private(set) var max: T
   public var current: T {
      get {
         return _current
      }
      set {
         var value = newValue
         if value < min {
            value = min
         }
         if value > max {
            value = max
         }
         _current = value
      }
   }

   private var _current: T
   public private(set) var defaultValue: T
   public init(min aMin: T, max aMax: T, defaultValue aDefValue: T) {
      assert(aMin < aMax && aDefValue <= aMax && aDefValue >= aMin)
      min = aMin
      max = aMax
      defaultValue = aDefValue
      _current = defaultValue
   }

   public mutating func reset() {
      _current = defaultValue
   }

   public var relativeValue: Double {
      get {
         return (current - min).doubleValue / (max - min).doubleValue
      } set {
         current = min + (max - min) * newValue
      }
   }
}
