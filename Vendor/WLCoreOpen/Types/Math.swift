//
//  Math.swift
//  WLCore
//
//  Created by Vlad Gorlov on 27.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Darwin

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

	public static func gcd<T: IntegerType>(valueA: T, _ valueB: T) -> T {
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
		var devider: Double = 1
		var result = scaleCoefficient
		while result > Double(maxBufferSize) {
			devider += 1
			result = scaleCoefficient / devider
		}
			return (optimalBufferSize: UInt64(ceil(result)), numberOfBuffers: UInt(devider) )
	}

}
