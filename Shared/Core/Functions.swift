//
//  Functions.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 25.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public struct g { // swiftlint:disable:this type_name
}

extension g {

   public static func perform<T>(_ closure: @noescape (Void) throws -> T?, failure: @noescape (ErrorProtocol) -> Void) -> T? {
      do {
         return try closure()
      } catch {
         failure(error)
         return nil
      }
   }

   public static func perform<T>(_ closure: @autoclosure (Void) throws -> T?, failure: (ErrorProtocol) -> Void) -> T? {
      do {
         return try closure()
      } catch {
         failure(error)
         return nil
      }
   }

   public static func perform(_ closure: @noescape (Void) throws -> Void, failure: @noescape (ErrorProtocol) -> Void) {
      do {
         try closure()
      } catch {
         failure(error)
      }
   }

   public static func perform(_ closure: @autoclosure (Void) throws -> Void, failure: (ErrorProtocol) -> Void) {
      do {
         try closure()
      } catch {
         failure(error)
      }
   }

   public static func configure<T>(_ element: T, _ closure: @noescape (T) -> Void) -> T {
      closure(element)
      return element
   }

   public static func configureEach<T>(_ elements: [T], _ closure: @noescape (T) -> Void) {
      elements.forEach { closure($0) }
   }

}


// MARK:

extension g {
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
   public static func benchmark(_ closure: @noescape (Void) -> Void) -> CFTimeInterval {
      let startTime = CFAbsoluteTimeGetCurrent()
      closure()
      return CFAbsoluteTimeGetCurrent() - startTime
   }

   public static func string(fromClass cls: AnyClass) -> String {
      return NSStringFromClass(cls)
   }

   // MARK:

   public static func map<A, B>(arg: A?, closure: (A) -> B) -> B? {
      if let value = arg {
         return closure(value)
      }
      return nil
   }

}
