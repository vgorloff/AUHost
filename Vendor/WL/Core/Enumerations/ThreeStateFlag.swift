//
//  ThreeStateFlag.swift
//  WLCore
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public enum ThreeStateFlag: Int {
	case FladUndefined = -1
	case FladOn = 1
	case FladOff = 0
	public init(fromBool: Bool) {
		self = fromBool ? FladOn : FladOff
	}
	public var boolValue: Bool {
		return self == FladOn ? true : false
	}
}
