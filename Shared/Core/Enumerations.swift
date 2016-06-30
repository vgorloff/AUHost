//
//  Enumerations.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public enum ResultType<T> {
	case Success(T)
	case Failure(ErrorType)
}

public enum StateError: ErrorType {
	case UnableToInitialize(String)
	case NotInitialized(String)
	case ResourceIsNotAvailable(String)
}

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
