//
//  Math.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.01.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct Math {

   public static func valueInRange<T: Comparable>(_ value: T, min minValue: T, max maxValue: T) -> T {
      let tmpValue = min(value, maxValue)
      return max(tmpValue, minValue)
   }

   public static func average(valueA: Float, _ valueB: Float) -> Float {
      return 0.5 * (valueA + valueB)
   }

   public static func isPrime(number: UInt64) -> Bool {
      assert(number >= 0)
      if number == 1 || number == 0 {
         return false
      }
      if number == 2 {
         return true
      }

      let upperBound = UInt64(ceil(sqrt(Double(number))))
      var currentValue: UInt64 = 2
      while currentValue <= upperBound {
         let modN = number % currentValue
         if modN == 0 {
            return false
         }
         currentValue += 1
      }
      return true
   }

   public static func gcd<T: BinaryInteger>(valueA: T, _ valueB: T) -> T {
      var divisor = max(valueA, valueB)
      repeat {
         if valueA % divisor == 0, valueB % divisor == 0 {
            return divisor
         }
         divisor = divisor - 1 // swiftlint:disable:this shorthand_operator
      } while divisor >= 2
      return 1
   }

   // |-----|-----|-----|-----|-----|---|   -> Bad
   // |-----|-----|-----|-----|-----|-----| -> Good
   public static func optimalBufferSizeForResolution(resolution: UInt64, dataSize: UInt64, maxBufferSize: UInt64) ->
      (optimalBufferSize: UInt64, numberOfBuffers: UInt) {
      assert(resolution > 0)
      let scaleCoefficient = Double(dataSize) / Double(resolution)
      var divider: Double = 1
      var result = scaleCoefficient
      while result > Double(maxBufferSize) {
         divider += 1
         result = scaleCoefficient / divider
      }
      return (optimalBufferSize: UInt64(ceil(result)), numberOfBuffers: UInt(divider))
   }

   // Next power of two greater or equal to x
   public func nextPowerOfTwo(_ value: UInt32) -> UInt32 {
      // TODO: Performance optimization required. See: http://stackoverflow.com/questions/466204/rounding-up-to-nearest-power-of-2
      var power: UInt32 = 1
      while power < value {
         power *= 2
      }
      return power
   }
}
