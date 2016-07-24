//
//  Enumerations.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

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

public enum BuildVariant {
	case Debug
	case TestFlight
	case AppStore

	// This is private because the use of 'appConfiguration' is preferred.
	private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"

	// This can be used to add debug statements.
	private static var isDebug: Bool {
		#if DEBUG // Do not forget to add -D DEBUG to "Swift Compiler Custom Flags"
			return true
		#else
			return false
		#endif
	}

	public static var isAppStore: Bool {
		return current == .AppStore
	}

	public static var current: BuildVariant {
		if isDebug {
			return .Debug
		} else if isTestFlight {
			return .TestFlight
		} else {
			return .AppStore
		}
	}
}
