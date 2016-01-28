//
//  UtilityTypes.swift
//  WLShared
//
//  Created by Vlad Gorlov on 27.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public struct AlternativeValue<T> {
	public var value: T
	public var altValue: T
	public var currentValue: T {
		return useAltValue ? altValue : value
	}
	public var useAltValue: Bool = false
	public init(_ v: T, altValue av: T) {
		value = v
		altValue = av
	}
}