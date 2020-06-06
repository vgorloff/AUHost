//
//  Functions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 12.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public func string(fromClass cls: AnyClass) -> String {
   return NSStringFromClass(cls)
}

public func throwIfNeeded(_ error: Swift.Error?) throws {
   if let error = error {
      throw error
   }
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

public func bridgeTransfer<T: AnyObject>(ptr: UnsafeRawPointer) -> T {
   return Unmanaged<T>.fromOpaque(ptr).takeRetainedValue()
}

public func bridge<T: AnyObject>(buffer: UnsafePointer<UnsafeRawPointer>, length: Int) -> [T] {
   var result: [T] = []
   for index in 0 ..< length {
      let item: T = bridge(ptr: buffer[index])
      result.append(item)
   }
   return result
}
