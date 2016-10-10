/// File: Logger.swift
/// Project: WaveLabs
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation
import os.log

public struct Logger {

   public enum Subsystem: Int {
      case Default = 1000
      case Network
      case Data
      case Model
      case View
      case Controller
      case Media
      case System
      case Delegate

      var stringValue: String {
         switch self {
         case .Default: return "ua.com.wavelabs.default"
         case .Network: return "ua.com.wavelabs.network"
         case .Data: return "ua.com.wavelabs.data"
         case .Model: return "ua.com.wavelabs.model"
         case .View: return "ua.com.wavelabs.view"
         case .Controller: return "ua.com.wavelabs.controller"
         case .Media: return "ua.com.wavelabs.media"
         case .System: return "ua.com.wavelabs.system"
         case .Delegate: return "ua.com.wavelabs.delegate"
         }
      }
   }

   public enum Category: Int {
      case Generic = 1
      case Fetch, Create, Push
      case Encode, Decode
      case Save, Delete
      case Init, Deinit, SetUp
      case Handle, Register, Diagnostics, Request
      case Lifecycle, Render
      case Open, Close, Reload

      var stringValue: String {
         switch self {
         case .Generic: return "Generic"
         case .Fetch: return "Fetch"
         case .Create: return "Create"
         case .Push: return "Push"
         case .Encode: return "Encode"
         case .Decode: return "Decode"
         case .Save: return "Save"
         case .Delete: return "Delete"
         case .Init: return "Init"
         case .Deinit: return "Deinit"
         case .SetUp: return "SetUp"
         case .Handle: return "Handle"
         case .Register: return "Register"
         case .Diagnostics: return "Diagnostics"
         case .Lifecycle: return "Lifecycle"
         case .Request: return "Request"
         case .Open: return "Open"
         case .Close: return "Close"
         case .Reload: return "Reload"
         case .Render: return "Render"
         }
      }
   }

   private static var loggers = [Int: OSLog]()

   // MARK: Private

   @available(OSX 10.12, *)
   private static func getLogger(subsystem: Subsystem, category: Category) -> OSLog {
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
   private static func format<T>(_ message: T, function: String, file: String, line: Int32) -> String {
      return "\(message) → \(function) ⋆ \(file.lastPathComponent):\(line)"
   }

   // MARK: - Public

   public static func initialize(subsystem: Subsystem,
                                 function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: .Init)
         let message = format("+++", function: function, file: file, line: line)
         log_public(logger, .debug, message)
      }
   }

   public static func deinitialize(subsystem: Subsystem,
                                   function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: .Deinit)
         let message = format("~~~", function: function, file: file, line: line)
         log_public(logger, .debug, message)
      }
   }

   public static func fault<T>(subsystem: Subsystem, category: Category, message: T,
                            function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         log_public(logger, .fault, message)
      }
   }

   public static func error<T>(subsystem: Subsystem, category: Category, message: T,
                            function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         log_public(logger, .error, message)
      }
   }

   public static func info<T>(subsystem: Subsystem, category: Category, message: T,
                           function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         log_public(logger, .info, message)
      }
   }

   public static func debug<T>(subsystem: Subsystem, category: Category, message: T,
                            function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         log_public(logger, .debug, message)
      }
   }

   public static func `default`<T>(subsystem: Subsystem, category: Category, message: T,
                                function: String = #function, file: String = #file, line: Int32 = #line) {
      if #available(OSX 10.12, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         log_public(logger, .default, message)
      }
   }

   public static func fault<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool) {
      guard expression() else { return }
      if #available(OSX 10.12, *) {
         fault(subsystem: subsystem, category: category, message: message)
      }
   }

   public static func error<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool) {
      guard expression() else { return }
      if #available(OSX 10.12, *) {
         error(subsystem: subsystem, category: category, message: message)
      }
   }

   public static func info<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool) {
      guard expression() else { return }
      if #available(OSX 10.12, *) {
         info(subsystem: subsystem, category: category, message: message)
      }
   }

   public static func debug<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool) {
      guard expression() else { return }
      if #available(OSX 10.12, *) {
         debug(subsystem: subsystem, category: category, message: message)
      }
   }

   public static func `default`<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool) {
      guard expression() else { return }
      if #available(OSX 10.12, *) {
         `default`(subsystem: subsystem, category: category, message: message)
      }
   }
}
