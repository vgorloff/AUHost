//
//  Assertion.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct Assertion {

   public static func unknown<T: Any>(_ instance: T, file: StaticString = #file, line: UInt = #line) {
      if !RuntimeInfo.isAssertionsDisabled {
         assertionFailure("Unknown value: \"\(instance)\". Please update \(#file).", file: file, line: line)
      }
   }

   public static func failure(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
      if !RuntimeInfo.isAssertionsDisabled {
         assertionFailure(message(), file: file, line: line)
      }
   }

   public static func shouldNeverHappen(file: StaticString = #file, line: UInt = #line) {
      if !RuntimeInfo.isAssertionsDisabled {
         assertionFailure("Should never happen!", file: file, line: line)
      }
   }

   public static func failure(_ error: Error, file: StaticString = #file, line: UInt = #line) throws {
      if RuntimeInfo.isUnderTesting {
         throw error
      } else {
         failure(String(describing: error))
      }
   }

   public static func verify(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(),
                             file: StaticString = #file, line: UInt = #line) {
      if !RuntimeInfo.isAssertionsDisabled {
         assert(condition(), message(), file: file, line: line)
      }
   }
}
