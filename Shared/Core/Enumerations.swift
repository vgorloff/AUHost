//
//  Enumerations.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public enum ResultType<T> {
	case success(T)
	case failure(Error)
}

public enum TripleStateSwitch: Int {
	case undefined = -1
	case on = 1
	case off = 0
	public init(fromBool: Bool) {
		self = fromBool ? .on : .off
	}
	public var boolValue: Bool {
		return self == .on ? true : false
	}
}

public enum BuildVariant {
	case debug
	case testFlight
	case appStore

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
		return current == .appStore
	}

	public static var current: BuildVariant {
		if isDebug {
			return .debug
		} else if isTestFlight {
			return .testFlight
		} else {
			return .appStore
		}
	}
}
