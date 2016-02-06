//
//  MinMax.swift
//  WLCore
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public struct MinMax<T: Comparable> {
	public var min: T
	public var max: T
	public init(min aMin: T, max aMax: T) {
		min = aMin
		max = aMax
	}
	public init(valueA: MinMax, valueB: MinMax) {
		min = Swift.min(valueA.min, valueB.min)
		max = Swift.max(valueA.max, valueB.max)
	}
}
