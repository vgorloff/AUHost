//
//  Functions.swift
//  mcFoundation
//
//  Created by Vlad Gorlov on 12.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

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

public func noop(_ any: Any) {
}

public func string(fromClass cls: AnyClass) -> String {
   return NSStringFromClass(cls)
}

public func throwIfNeeded(_ error: Swift.Error?) throws {
   if let error = error {
      throw error
   }
}

@discardableResult
public func configure<T>(_ element: T, _ closure: (T) -> Void) -> T {
   closure(element)
   return element
}

public func map<A, B>(arg: A?, closure: (A) -> B) -> B? {
   if let value = arg {
      return closure(value)
   }
   return nil
}

/// See: https://stackoverflow.com/a/33310021/1418981

public func bridge<T: AnyObject>(obj: T) -> UnsafeRawPointer {
   return UnsafeRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

public func bridge<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
   return Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}

public func bridgeRetained<T: AnyObject>(obj: T) -> UnsafeRawPointer {
   return UnsafeRawPointer(Unmanaged.passRetained(obj).toOpaque())
}

public func bridgeTransfer<T : AnyObject>(ptr: UnsafeRawPointer) -> T {
   return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}

public func bridge<T: AnyObject>(buffer: UnsafePointer<UnsafeRawPointer>, length: Int) -> Array<T> {
   var result: [T] = []
   for index in 0 ..< length {
      let item: T = bridge(ptr: buffer[index])
      result.append(item)
   }
   return result
}
