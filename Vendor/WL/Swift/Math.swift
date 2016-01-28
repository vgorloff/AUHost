//
//  Math.swift
//  WLShared
//
//  Created by Vlad Gorlov on 27.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

public struct MinMax<T: Comparable> {
	public var min: T
	public var max: T
	public init(min aMin: T, max aMax: T) {
		min = aMin
		max = aMax
	}
	public init(a: MinMax, b: MinMax) {
		min = Swift.min(a.min, b.min)
		max = Swift.max(a.max, b.max)
	}
}

public struct Math {

	public static func average(a: Float, _ b: Float) -> Float {
		return 0.5 * (a + b)
	}

	public static func isPrime(n: UInt64) -> Bool {
		assert(n >= 0)
		if n == 1 || n == 0 {
			return false
		}
		if n == 2 {
			return true
		}

		let upperBound = UInt64(ceil(sqrt(Double(n))))
		var currentValue: UInt64 = 2
		while currentValue <= upperBound {
			let modN = n % currentValue
			if modN == 0 {
				return false
			}
			++currentValue
		}
		return true
	}

	public static func gcd<T: IntegerType>(a: T, _ b: T) -> T {
		for var divisor = max(a, b); divisor >= 2; --divisor {
			if a % divisor == 0 && b % divisor == 0 {
				return divisor
			}
		}
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
			devider++
			result = scaleCoefficient / devider
		}
			return (optimalBufferSize: UInt64(ceil(result)), numberOfBuffers: UInt(devider) )
	}

}