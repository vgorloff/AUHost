//
//  Math.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 27.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Darwin

/// - SeeAlso: [ How does one generate a random number in Apple's Swift language? - Stack Overflow ]
/// (http://stackoverflow.com/questions/24007129/how-does-one-generate-a-random-number-in-apples-swift-language)
protocol RandomInRangeValueType: Comparable {
   static func randomValue(in: Range<Self>) -> Self
}

extension UInt32: RandomInRangeValueType {
   static func randomValue(in range: Range<UInt32>) -> UInt32 {
      let upperBound = (range.upperBound - range.lowerBound)
      let randomNumber = arc4random_uniform(upperBound)
      return range.lowerBound + randomNumber
   }
}

extension Float: RandomInRangeValueType {
   static func randomValue(in range: Range<Float>) -> Float {
      var randomValue: UInt32 = 0
      arc4random_buf(&randomValue, sizeof(UInt32.self))
      let randomValueFloat = Float(randomValue) / Float(UInt32.max)
      return (randomValueFloat * (range.upperBound - range.lowerBound)) + range.lowerBound
   }
}

public struct Math {

	public static func PlaceValueInRange<T: Comparable>(value: T, min: T, max: T) -> T {
		var result = value
		if value < min {
			result = min
		}
		if value > max {
			result = max
		}
		return result
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

	public static func gcd<T: Integer>(valueA: T, _ valueB: T) -> T {
		var divisor = max(valueA, valueB)
		repeat {
			if valueA % divisor == 0 && valueB % divisor == 0 {
				return divisor
			}
			divisor = divisor - 1
		}
		while (divisor >= 2)
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
			return (optimalBufferSize: UInt64(ceil(result)), numberOfBuffers: UInt(divider) )
	}

}
