//
//  Log.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.01.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxConcurrencyLocking
import mcxRuntime
import os.log

private class LogBundle {
   static let isCommandLine = {
      Bundle(for: LogBundle.self).bundleIdentifier == nil
         || CommandLine.arguments.first == "ruby"
         || CommandLine.arguments.first == "node"
   }()
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
   private let lock = UnfairLock() // Not used in Production builds.
   private var traceFilePath: String?
   private let isTracingEnabled: Bool
   private var isTracingInitialized = false

   public init(subsystem: String) {
      self.subsystem = subsystem
      isTracingEnabled = RuntimeInfo.isTracingEnabled && RuntimeInfo.isLoggingEnabled && RuntimeInfo.isLocalRun && !BuildInfo.isAppStore
      if isTracingEnabled, let traceLogsDirPath = RuntimeInfo.traceLogsDirPath {
         let traceFilePath = (traceLogsDirPath as NSString).appendingPathComponent("\(subsystem).log")
         self.traceFilePath = traceFilePath
      }
   }
}

extension Log {

   public func trace<T: CustomStringConvertible>(_ message: T, shouldSaveToFile: Bool = false,
                                                 function: String = #function, file: String = #file,
                                                 line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      trace(message.description, shouldSaveToFile: shouldSaveToFile, function: function, file: file, line: line, dso: dso)
   }

   public func trace(_ message: String, shouldSaveToFile: Bool = false, function: String = #function, file: String = #file,
                     line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard isTracingEnabled || LogBundle.isCommandLine else {
         return
      }
      let filename = (file as NSString).lastPathComponent
      var msg = "[T] \(filename):\(line): \(message)"
      if LogBundle.isCommandLine {
         // Dimmed color: https://misc.flogisoft.com/bash/tip_colors_and_formatting
         msg = "\(message) \u{001B}[2m@ \(filename):\(line)\u{001B}[0;m"
      }
      lock.synchronized {
         if shouldSaveToFile {
            createLogFileIfNeeded()
            if let traceFilePath = traceFilePath, let data = (msg + "\n").data(using: .utf8) {
               let handle = FileHandle(forWritingAtPath: traceFilePath)
               handle?.seekToEndOfFile()
               handle?.write(data)
               handle?.closeFile()
            }
         } else {
            print(msg)
            fflush(stdout)
         }
      }
   }
}

extension Log {

   public func initialize(_ message: String? = nil, function: String = #function, file: String = #file,
                          line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      logInit(message, function: function, file: file, line: line, dso: dso)
   }

   public func deinitialize(_ message: String? = nil, function: String = #function, file: String = #file, line: Int32 = #line,
                            dso: UnsafeRawPointer? = #dsohandle) {
      logDeinit(message, function: function, file: file, line: line, dso: dso)
   }

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

   public func initialize(_ message: String? = nil, if expression: @autoclosure () -> Bool, function: String = #function,
                          file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      logInit(message, function: function, file: file, line: line, dso: dso)
   }

   public func deinitialize(_ message: String? = nil, if expression: @autoclosure () -> Bool, function: String = #function,
                            file: String = #file, line: Int32 = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard expression() else { return }
      logDeinit(message, function: function, file: file, line: line, dso: dso)
   }

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

   private func logInit(_ message: String?, function: String, file: String, line: Int32, dso: UnsafeRawPointer?) {
      if BuildInfo.isAppStore {
         return
      }
      if !RuntimeInfo.isLoggingEnabled {
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

   private func logDeinit(_ message: String?, function: String, file: String, line: Int32, dso: UnsafeRawPointer?) {
      if BuildInfo.isAppStore {
         return
      }
      if !RuntimeInfo.isLoggingEnabled {
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

   // swiftlint:disable:next function_parameter_count
   private func log(type: OSLogType, category: T, message: String,
                    function: String, file: String, line: Int32, dso: UnsafeRawPointer?) {
      if #available(OSX 10.12, iOS 10.0, *) {
         if BuildInfo.isAppStore, type == .debug {
            return
         }
         if !RuntimeInfo.isLoggingEnabled {
            return
         }
         let logger = osLog(category: category.rawValue)
         let message = format(message, function: function, file: file, line: line)
         log(type: type, message: message, logger: logger, dso: dso)
      }
   }

   private func log(type: OSLogType, message: String, logger: OSLog, dso: UnsafeRawPointer?) {
      if #available(OSX 10.12, iOS 10.0, *) {
         var prefix = ""
         if type == .error || type == .fault {
            prefix = "‼️"
         } else if type == .info || type == .default {
            prefix = "⚠️"
         } else {
            prefix = "→"
         }
         let msg = "[\(type.codeValue)] \(prefix) \(message)"
         if RuntimeInfo.isInsidePlayground || LogBundle.isCommandLine || BuildInfo.isDebug {
            lock.synchronized {
               print(msg)
               fflush(stdout)
            }
         } else {
            os_log("%{public}@", dso: dso, log: logger, type: type, msg)
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
      if BuildInfo.isDebug, !LogBundle.isCommandLine {
         msg = "\(filename):\(line) → \(message)"
      } else {
         msg = "\(filename):\(line) ⋆ \(function) → \(message)"
      }
      return msg
   }

   private func createLogFileIfNeeded() {
      if !isTracingInitialized, let traceFilePath = traceFilePath {
         do {
            try FileManager.default.createDirectory(atPath: (traceFilePath as NSString).deletingLastPathComponent,
                                                    withIntermediateDirectories: true)
            var isDir = ObjCBool(false)
            let isExists = FileManager.default.fileExists(atPath: traceFilePath, isDirectory: &isDir)
            if isExists, !isDir.boolValue {
               try FileManager.default.removeItem(atPath: traceFilePath)
            }
            FileManager.default.createFile(atPath: traceFilePath, contents: nil, attributes: nil)
            isTracingInitialized = true
         } catch {
            print(String(describing: error))
         }
      }
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
