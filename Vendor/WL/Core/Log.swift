/// File: Log.swift
/// Project: WaveLabs
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation
import os.log

public struct Log {

   fileprivate static let vendorID = "ua.com.wavelabs"

   public enum Subsystem: Int {
      case `default` = 1000
      case core
      case db
      case net
      case media
      case io
      case model
      case view
      case controller
   }

   public enum Category: Int {
      case generic = 1
      case encode, decode
      case initialise, deinitialize
      case request, response
      case event
      case fetch
      case access
   }

   fileprivate static var loggers = [Int: OSLog]()
}

extension Log {

   public static func initialize(subsystem: Subsystem, function: String = #function, file: String = #file, line: Int32 = #line,
                                 dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: .initialise)
         let message = format("+++", function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .debug, message)
      }
   }

   public static func initialize(subsystem: Subsystem, message: String, function: String = #function, file: String = #file,
                                 line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: .initialise)
         let message = format("+++ \(message)", function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .debug, message)
      }
   }

   public static func deinitialize(subsystem: Subsystem, function: String = #function, file: String = #file, line: Int32 = #line,
                                   dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: .deinitialize)
         let message = format("~~~", function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .debug, message)
      }
   }

   public static func deinitialize(subsystem: Subsystem, message: String, function: String = #function, file: String = #file,
                                   line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: .deinitialize)
         let message = format("~~~ \(message)", function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .debug, message)
      }
   }

   public static func fault(subsystem: Subsystem, category: Category, message: String, function: String = #function,
                            file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .fault, message)
      }
   }

   public static func error(subsystem: Subsystem, category: Category, message: String, function: String = #function,
                            file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .error, message)
      }
   }

   public static func error<T>(subsystem: Subsystem, category: Category, object: T, function: String = #function,
                               file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      error(subsystem: subsystem, category: category, message: String(describing: object))
   }

   public static func error(subsystem: Subsystem, category: Category, error: Swift.Error, function: String = #function,
                            file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(error.localizedDescription, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .error, message)
      }
   }

   public static func info(subsystem: Subsystem, category: Category, message: String, function: String = #function,
                           file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .info, message)
      }
   }

   public static func debug(subsystem: Subsystem, category: Category, message: String, function: String = #function,
                            file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .debug, message)
      }
   }

   public static func `default`(subsystem: Subsystem, category: Category, message: String, function: String = #function,
                                file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .default, message)
      }
   }

   public static func fault(subsystem: Subsystem, category: Category, message: String, if expression: @autoclosure () -> Bool,
                            function: String = #function, file: String = #file, line: Int32 = #line,
                            dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         fault(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public static func error(subsystem: Subsystem, category: Category, message: String, if expression: @autoclosure () -> Bool,
                            function: String = #function, file: String = #file, line: Int32 = #line,
                            dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         error(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public static func info(subsystem: Subsystem, category: Category, message: String, if expression: @autoclosure () -> Bool,
                           function: String = #function, file: String = #file, line: Int32 = #line,
                           dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         info(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public static func debug(subsystem: Subsystem, category: Category, message: String, if expression: @autoclosure () -> Bool,
                            function: String = #function, file: String = #file, line: Int32 = #line,
                            dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         debug(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }

   public static func `default`(subsystem: Subsystem, category: Category, message: String, if expression: @autoclosure () -> Bool,
                                function: String = #function, file: String = #file, line: Int32 = #line,
                                dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         `default`(subsystem: subsystem, category: category, message: message, function: function,
                   file: file, line: line, dso: dso)
      }
   }
}

extension Log {

   @available(OSX 10.12, iOS 10.0, *)
   fileprivate static func getLogger(subsystem: Subsystem, category: Category) -> OSLog {
      let key = subsystem.rawValue + category.rawValue
      if let logger = loggers[key] {
         return logger
      } else {
         let logger = OSLog(subsystem: subsystem.stringValue, category: category.stringValue)
         loggers[key] = logger
         return logger
      }
   }

   @available(OSX 10.12, *)
   fileprivate static func format(_ message: String, function: String, file: String, line: Int32) -> String {
      let filename = (file as NSString).lastPathComponent
      return "\(message) → \(function) ⋆ \(filename):\(line)"
   }
}

extension Log.Subsystem {

   fileprivate var stringValue: String {
      switch self {
      case .default: return "\(Log.vendorID).default"
      case .net: return "\(Log.vendorID).network"
      case .db: return "\(Log.vendorID).db"
      case .model: return "\(Log.vendorID).model"
      case .view: return "\(Log.vendorID).view"
      case .controller: return "\(Log.vendorID).controller"
      case .media: return "\(Log.vendorID).media"
      case .core: return "\(Log.vendorID).core"
      case .io: return "\(Log.vendorID).io"
      }
   }
}

extension Log.Category {

   fileprivate var stringValue: String {
      switch self {
      case .generic: return "Generic"
      case .fetch: return "Fetch"
      case .encode: return "Encode"
      case .decode: return "Decode"
      case .initialise: return "Init"
      case .deinitialize: return "Deinit"
      case .request: return "Request"
      case .response: return "Response"
      case .event: return "Event"
      case .access: return "Access"
      }
   }
}
