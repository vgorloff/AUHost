//
//  Functions.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 25.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

/// Executes throwing expression and prints error if happens. **Note** Version can not be used inside blocks.
/// - parameter closure: Expression to execute.
/// - returns: nil if error happens, otherwise returns some value.
public func tryAndPrintError<T>(@autoclosure closure: () throws -> T?) -> T? {
	do {
		return try closure()
	} catch {
		print(error)
		return nil
	}
}

@available(*, renamed="tryAndPrintError")
public func trythrow<T>(@autoclosure closure: () throws -> T?) -> T? {
	return tryAndPrintError(closure)
}

public func tryReturnOrCrash<T>(@autoclosure closure: () throws -> T) -> T {
	do {
		return try closure()
	} catch {
		fatalError("\(error)")
	}
}

@available(*, renamed="tryReturnOrCrash")
public func trycrash<T>(@autoclosure closure: () throws -> T) -> T {
	return tryReturnOrCrash(closure)
}

/// Executes throwing expression and prints error if happens. **Note** Version can be used inside blocks.
/// - parameter closure: Expression to execute.
/// - returns: nil if error happens, otherwise returns some value.
public func tryAndPrintError<T>(@noescape closure: () throws -> T?) -> T? {
	do {
		return try closure()
	} catch {
      print(error)
		return nil
	}
}

@available(*, renamed="tryAndPrintError")
public func trythrow<T>(@noescape closure: () throws -> T?) -> T? {
	return tryAndPrintError(closure)
}

public func tryReturnOrCrash<T>(@noescape closure: () throws -> T) -> T {
	do {
		return try closure()
	} catch {
		fatalError("\(error)")
	}
}

@available(*, renamed="tryReturnOrCrash")
public func trycrash<T>(@noescape closure: () throws -> T) -> T {
	return tryReturnOrCrash(closure)
}

public func tryAndReturn<T>(@noescape closure: () throws -> T) -> ResultType<T> {
	do {
		return ResultType.Success(try closure())
	} catch {
		return ResultType.Failure(error)
	}
}

// MARK: -

/// - parameter object: Object instance.
/// - returns: Object address pointer as Int.
public func pointerAddressOf(object: AnyObject) -> Int {
   let ptr = unsafeAddressOf(object)
   let nullPtr = UnsafePointer<Void>(bitPattern: 0)

   /// This gets the address of pointer
   let address = nullPtr.distanceTo(ptr)
   return address
}

public func randomNumberBetween(min: UInt32, max: UInt32) -> UInt32 {
	return min + arc4random_uniform(max - min + 1)
}

/// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
public func noop() {
}

/// - returns: Time interval in seconds.
/// - parameter closure: Code block to measure performance.
public func benchmark(@noescape closure: Void -> Void) -> CFTimeInterval {
	let startTime = CFAbsoluteTimeGetCurrent()
	closure()
	return CFAbsoluteTimeGetCurrent() - startTime
}

public func StringFromClass(aClass: AnyClass) -> String {
	return NSStringFromClass(aClass.self)
}

// MARK: -

func map<A, B>(arg: A?, closure: A -> B) -> B? {
	if let value = arg {
		return closure(value)
	}
	return nil
}
