//
//  Assertion.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

private let log = Logger.getLogger(Assertion.self)

public struct Assertion {

   public static func unknown<T: Any>(_ instance: T, file: StaticString = #file, line: UInt = #line) {
      if RuntimeInfo.isAssertionsEnabled {
         assertionFailure("Unknown value: \"\(instance)\". Please update \(file).", file: file, line: line)
      } else {
         log.error("Unknown value: \"\(instance)\". Please update \(file).")
      }
   }

   public static func failure(_ message: @autoclosure () -> String = String(), file: StaticString = #file, line: UInt = #line) {
      if RuntimeInfo.isAssertionsEnabled {
         assertionFailure(message(), file: file, line: line)
      } else {
         log.error("\(message()). See: \(file).")
      }
   }

   public static func shouldNeverHappen(file: StaticString = #file, line: UInt = #line) {
      if RuntimeInfo.isAssertionsEnabled {
         assertionFailure("Should never happen!", file: file, line: line)
      } else {
         log.error("Should never happen!. See: \(file).")
      }
   }

   public static func failure(_ error: Error, file: StaticString = #file, line: UInt = #line) {
      if RuntimeInfo.isAssertionsEnabled {
         assertionFailure(String(describing: error), file: file, line: line)
      } else {
         log.error("\(String(describing: error)). See: \(file).")
      }
   }

   public static func verify(_ condition: @autoclosure () -> Bool, _ message: @autoclosure () -> String = String(),
                             file: StaticString = #file, line: UInt = #line) {
      let cond = condition()
      if RuntimeInfo.isAssertionsEnabled {
         assert(cond, message(), file: file, line: line)
      } else {
         if cond {
            log.error("\(message()). See: \(file).")
         }
      }
   }
}
