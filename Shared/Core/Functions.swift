//
//  Functions.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 25.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

/// Executes throwing expression and prints error if happens. **Note** Version can not be used inside blocks.
/// - parameter closure: Expression to execute.
/// - returns: nil if error happens, otherwise returns some value.
public func tryOrWarn<T>( closure: @autoclosure() throws -> T?) -> T? {
	do {
		return try closure()
	} catch {
		print(error)
		return nil
	}
}

public func tryOrWarn( closure: @autoclosure() throws -> Void) {
	do {
		try closure()
	} catch {
		print(error)
	}
}

/// Executes throwing expression and prints error if happens. **Note** Version can be used inside blocks.
/// - parameter closure: Expression to execute.
/// - returns: nil if error happens, otherwise returns some value.
public func tryOrWarn<T>( closure: @noescape() throws -> T?) -> T? {
	do {
		return try closure()
	} catch {
      print(error)
		return nil
	}
}

public func tryOrWarn( closure: @noescape() throws -> Void) {
	do {
		try closure()
	} catch {
		print(error)
	}
}

public func tryAndReturn<T>( closure: @noescape() throws -> T) -> ResultType<T> {
	do {
		return ResultType.Success(try closure())
	} catch {
		return ResultType.Failure(error)
	}
}

// MARK: -

/// - parameter object: Object instance.
/// - returns: Object address pointer as Int.
/// - SeeAlso: [ Printing a variable memory address in swift - Stack Overflow ]
///            (http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
public func pointerAddress(of object: AnyObject) -> Int {
	return unsafeBitCast(object, to: Int.self)
}

/// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
public func noop() {
}

/// - returns: Time interval in seconds.
/// - parameter closure: Code block to measure performance.
public func benchmark(closure: @noescape (Void) -> Void) -> CFTimeInterval {
	let startTime = CFAbsoluteTimeGetCurrent()
	closure()
	return CFAbsoluteTimeGetCurrent() - startTime
}

public func StringFromClass(_ cls: AnyClass) -> String {
	return NSStringFromClass(cls.self)
}

// MARK: -

func map<A, B>(arg: A?, closure: (A) -> B) -> B? {
	if let value = arg {
		return closure(value)
	}
	return nil
}
