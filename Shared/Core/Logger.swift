/// File: Logger.swift
/// Project: WaveLabs
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation
import os.log

public struct Logger {
   
   public enum Subsystem: Int {
      case `default` = 1000
      case network
      case data
      case model
      case view
      case controller
      case media
      case system
      case delegate
   }
   
   public enum Category: Int {
      case generic = 1
      case fetch, create, push
      case encode, decode
      case save, delete
      case initialise, deinitialize, setup
      case handle, register, diagnostics, request
      case lifecycle, render
      case open, close, reload
   }
   
   fileprivate static var loggers = [Int: OSLog]()
   
}

extension Logger {
   
   public static func initialize(subsystem: Subsystem, function: String = #function, file: String = #file, line: Int32 = #line,
                                 dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: .initialise)
         let message = format("+++", function: function, file: file, line: line)
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
   
   public static func fault<T>(subsystem: Subsystem, category: Category, message: T, function: String = #function,
                               file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .fault, message)
      }
   }
   
   public static func error<T>(subsystem: Subsystem, category: Category, message: T, function: String = #function,
                               file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .error, message)
      }
   }
   
   public static func info<T>(subsystem: Subsystem, category: Category, message: T, function: String = #function,
                              file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .info, message)
      }
   }
   
   public static func debug<T>(subsystem: Subsystem, category: Category, message: T, function: String = #function,
                               file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .debug, message)
      }
   }
   
   public static func `default`<T>(subsystem: Subsystem, category: Category, message: T, function: String = #function,
                                   file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let logger = getLogger(subsystem: subsystem, category: category)
         let message = format(message, function: function, file: file, line: line)
         os_log("%{public}@", dso: dso, log: logger, type: .default, message)
      }
   }
   
   public static func fault<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool,
                               function: String = #function, file: String = #file, line: Int32 = #line,
                               dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         fault(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }
   
   public static func error<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool,
                               function: String = #function, file: String = #file, line: Int32 = #line,
                               dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         error(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }
   
   public static func info<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool,
                              function: String = #function, file: String = #file, line: Int32 = #line,
                              dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         info(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }
   
   public static func debug<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool,
                               function: String = #function, file: String = #file, line: Int32 = #line,
                               dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         debug(subsystem: subsystem, category: category, message: message, function: function, file: file, line: line, dso: dso)
      }
   }
   
   public static func `default`<T>(subsystem: Subsystem, category: Category, message: T, if expression: @autoclosure() -> Bool,
                                   function: String = #function, file: String = #file, line: Int32 = #line,
                                   dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      if #available(OSX 10.12, iOS 10.0, *) {
         `default`(subsystem: subsystem, category: category, message: message, function: function,
                   file: file, line: line, dso: dso)
      }
   }
}

extension Logger {
   
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
   fileprivate static func format<T>(_ message: T, function: String, file: String, line: Int32) -> String {
      return "\(String(describing: message)) → \(function) ⋆ \(file.lastPathComponent):\(line)"
   }
}

extension Logger.Subsystem {
   
   fileprivate var stringValue: String {
      switch self {
      case .default: return "ua.com.wavelabs.default"
      case .network: return "ua.com.wavelabs.network"
      case .data: return "ua.com.wavelabs.data"
      case .model: return "ua.com.wavelabs.model"
      case .view: return "ua.com.wavelabs.view"
      case .controller: return "ua.com.wavelabs.controller"
      case .media: return "ua.com.wavelabs.media"
      case .system: return "ua.com.wavelabs.system"
      case .delegate: return "ua.com.wavelabs.delegate"
      }
   }
}

extension Logger.Category {
   
   fileprivate var stringValue: String {
      switch self {
      case .generic: return "Generic"
      case .fetch: return "Fetch"
      case .create: return "Create"
      case .push: return "Push"
      case .encode: return "Encode"
      case .decode: return "Decode"
      case .save: return "Save"
      case .delete: return "Delete"
      case .initialise: return "Init"
      case .deinitialize: return "Deinit"
      case .setup: return "SetUp"
      case .handle: return "Handle"
      case .register: return "Register"
      case .diagnostics: return "Diagnostics"
      case .lifecycle: return "Lifecycle"
      case .request: return "Request"
      case .open: return "Open"
      case .close: return "Close"
      case .reload: return "Reload"
      case .render: return "Render"
      }
   }
}
