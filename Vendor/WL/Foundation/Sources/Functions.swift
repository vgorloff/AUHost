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
