/// File: Log.swift
/// Project: mcFoundation
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation
import os.log

private class LogBundle {
   static let isCommandLine = Bundle(for: LogBundle.self).bundleIdentifier == nil
}

public protocol LogCategory {
   var rawValue: String { get }
}

public enum DefaultLogCategory: String, LogCategory {
   case `default`
   case core
   case db
   case net
   case media
   case io
   case service
   case model
   case view
   case controller
   case test
}

private let defaultLog = Log<DefaultLogCategory>(subsystem: "default")

/// Executes throwing expression and prints error if happens. **Note** Version can be used inside blocks.
/// - parameter closure: Expression to execute.
/// - returns: nil if error happens, otherwise returns some value.
public func configure<T>(reportingTo log: DefaultLogCategory, function: String = #function, file: String = #file,
                         line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle, closure: () throws -> T?) -> T? {
   do {
      return try closure()
   } catch {
      defaultLog.error(log, error, function: function, file: file, line: line, dso: dso)
      return nil
   }
}

public func configure(reportingTo log: DefaultLogCategory, function: String = #function, file: String = #file,
                      line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle, closure: () throws -> Void) {
   do {
      try closure()
   } catch {
      defaultLog.error(log, error, function: function, file: file, line: line, dso: dso)
   }
}

/// Executes throwing expression and prints error if happens. **Note** Version can not be used inside blocks.
/// - parameter closure: Expression to execute.
/// - returns: nil if error happens, otherwise returns some value.
public func configure<T>(reportingTo log: DefaultLogCategory, function: String = #function, file: String = #file,
                         line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle, closure: @autoclosure () throws -> T?) -> T? {
   do {
      return try closure()
   } catch {
      defaultLog.error(log, error, function: function, file: file, line: line, dso: dso)
      return nil
   }
}

public class Log<T: LogCategory> {

   private let vendorID = "com.mc"
   private let subsystem: String
   private var loggers = [Int: OSLog]()

   public init(subsystem: String) {
      self.subsystem = subsystem
   }
}

extension Log {
   public func initialize(_ message: String? = nil, function: String = #function, file: String = #file,
                          line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         guard !RuntimeInfo.isUnderTesting else {
            return
         }
         let logger = osLog(category: "init")
         let msg: String
         if let value = message {
            msg = format("+++ \(value)", function: function, file: file, line: line)
         } else {
            msg = format("+++", function: function, file: file, line: line)
         }
         log(type: .debug, message: msg, logger: logger, dso: dso)
      }
   }

   public func deinitialize(_ message: String? = nil, function: String = #function, file: String = #file, line: Int32 = #line,
                            dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         guard !RuntimeInfo.isUnderTesting else {
            return
         }
         let logger = osLog(category: "deinit")
         let msg: String
         if let value = message {
            msg = format("~~~ \(value)", function: function, file: file, line: line)
         } else {
            msg = format("~~~", function: function, file: file, line: line)
         }
         log(type: .debug, message: msg, logger: logger, dso: dso)
      }
   }
}

extension Log {

   public func fault(_ category: T, _ message: String, function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .fault, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func error(_ category: T, _ message: String, function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .error, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func error(_ category: T, _ error: Swift.Error, function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .error, category: category, message: String(describing: error),
             function: function, file: file, line: line, dso: dso)
      }
   }

   public func info(_ category: T, _ message: String, function: String = #function, file: String = #file, line: Int32 = #line,
                    dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .info, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func `default`(_ category: T, _ message: String, function: String = #function, file: String = #file,
                         line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .default, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func debug(_ category: T, _ message: String, function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .debug, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }
}

extension Log {

   public func fault(_ category: T, _ message: String, if expression: @autoclosure () -> Bool,
                     function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         fault(category, message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func error(_ category: T, _ message: String, if expression: @autoclosure () -> Bool,
                     function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         error(category, message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func error(_ category: T, _ error: Swift.Error, if expression: @autoclosure () -> Bool,
                     function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         log(type: .error, category: category, message: String(describing: error),
             function: function, file: file, line: line, dso: dso)
      }
   }

   public func info(_ category: T, _ message: String, if expression: @autoclosure () -> Bool,
                    function: String = #function, file: String = #file, line: Int32 = #line,
                    dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         info(category, message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func debug(_ category: T, _ message: String, if expression: @autoclosure () -> Bool,
                     function: String = #function, file: String = #file, line: Int32 = #line,
                     dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         debug(category, message, function: function, file: file, line: line, dso: dso)
      }
   }

   public func `default`(_ category: T, _ message: String, if expression: @autoclosure () -> Bool,
                         function: String = #function, file: String = #file, line: Int32 = #line,
                         dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         `default`(category, message, function: function, file: file, line: line, dso: dso)
      }
   }
}

extension Log {

   // swiftlint:disable:next function_parameter_count
   private func log(type: OSLogType, category: T, message: String,
                    function: String, file: String, line: Int32, dso: UnsafeRawPointer?) {
      if #available(OSX 10.12, iOS 10.0, *) {
         if BuildInfo.isAppStore && type == .debug {
            return
         }
         let logger = osLog(category: category.rawValue)
         let message = format(message, function: function, file: file, line: line)
         log(type: type, message: message, logger: logger, dso: dso)
      }
   }

   private func log(type: OSLogType, message: String, logger: OSLog, dso: UnsafeRawPointer?) {
      if #available(OSX 10.12, iOS 10.0, *) {
         if RuntimeInfo.isInsidePlayground || LogBundle.isCommandLine {
            print("[\(type.codeValue)] \(message)")
         } else {
            os_log("%{public}@", dso: dso, log: logger, type: type, message)
         }
      }
   }

   @available(OSX 10.12, iOS 10.0, *)
   private func osLog(category: String) -> OSLog {
      let key = category.hashValue
      if let logger = loggers[key] {
         return logger
      } else {
         let logger = OSLog(subsystem: vendorID + "." + subsystem, category: vendorID + "." + category)
         loggers[key] = logger
         return logger
      }
   }

   private func format(_ message: String, function: String, file: String, line: Int32) -> String {
      let filename = (file as NSString).lastPathComponent
      let msg: String
      if BuildInfo.isDebug {
         msg = "\(filename):\(line) ⋆ \(function)\n → \(message)"
      } else {
         msg = "\(filename):\(line) ⋆ \(function) → \(message)"
      }
      return msg
   }
}

extension OSLogType {

   @available(OSX 10.12, *)
   public var stringValue: String {
      switch self {
      case .default:
         return "default"
      case .info:
         return "info"
      case .debug:
         return "debug"
      case .error:
         return "error"
      case .fault:
         return "fault"
      default:
         return "unknown"
      }
   }

   @available(OSX 10.12, *)
   public var codeValue: String {
      switch self {
      case .default:
         return "D"
      case .info:
         return "I"
      case .debug:
         return "D"
      case .error:
         return "E"
      case .fault:
         return "F"
      default:
         return "U"
      }
   }
}
