//
//  Util.swift
//  NetServices
//
//  Created by Vlad Gorlov on 12.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public struct Util {
}

extension Util {

   public static func configure<T>(_ element: T, _ closure: (T) -> Void) -> T {
      closure(element)
      return element
   }

   public static func configureEach<T>(_ elements: [T], _ closure: (T) -> Void) {
      elements.forEach { closure($0) }
   }

}

extension Util {
   /// - parameter object: Object instance.
   /// - returns: Object address pointer as Int.
   /// - SeeAlso: [ Printing a variable memory address in swift - Stack Overflow ]
   ///            (http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
   public static func pointerAddress(of object: AnyObject) -> Int {
      return unsafeBitCast(object, to: Int.self)
   }

   /// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
   public static func noop() {
   }

   /// - returns: Time interval in seconds.
   /// - parameter closure: Code block to measure performance.
   public static func benchmark(_ closure: () -> Void) -> CFTimeInterval {
      let startTime = CFAbsoluteTimeGetCurrent()
      closure()
      return CFAbsoluteTimeGetCurrent() - startTime
   }

   public static func string(fromClass cls: AnyClass) -> String {
      return NSStringFromClass(cls)
   }

}
