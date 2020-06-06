//
//  Functions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

@discardableResult
public func configure<T>(_ element: T, _ closure: (T) -> Void) -> T {
   closure(element)
   return element
}

/// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
public func noop() {
}

/// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
public func noop(_: Any) {
}

/// - parameter object: Object instance.
/// - returns: Object address pointer as Int.
/// - SeeAlso: [ Printing a variable memory address in swift - Stack Overflow ]
///            (http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
public func pointerAddress(of object: AnyObject) -> Int {
   return unsafeBitCast(object, to: Int.self)
}
