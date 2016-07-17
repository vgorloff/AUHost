//
//  Enumerations.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public enum ResultType<T> {
	case Success(T)
	case Failure(ErrorProtocol)
}

public enum StateError: ErrorProtocol {
	case UnableToInitialize(String)
	case NotInitialized(String)
	case ResourceIsNotAvailable(String)
}

public enum TripleStateSwitch: Int {
	case Undefined = -1
	case On = 1
	case Off = 0
	public init(fromBool: Bool) {
		self = fromBool ? On : Off
	}
	public var boolValue: Bool {
		return self == On ? true : false
	}
}
