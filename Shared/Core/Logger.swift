/// File: Logger.swift
/// Project: WaveLabs
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation
import os.log

@available(OSX 10.12, *)
private let globalLogger = Logger(subsystem: .Default, category: .Global)

@available(OSX 10.12, *)
extension g {
   public static var log: Logger {
      return globalLogger
   }
}

@available(OSX 10.12, *)
public struct Logger {

   public enum Category {
      case Global
      case Network
      case Data
      case Model
      case View
      case Controller
      case Playback
      case Utility
      case Delegate

      var stringValue: String {
         switch self {
         case .Global: return "GLB"
         case .Network: return "NET"
         case .Data: return "DAT"
         case .Model: return "MOD"
         case .View: return "VIE"
         case .Controller: return "CRL"
         case .Playback: return "PBK"
         case .Utility: return "UTL"
         case .Delegate: return "DLG"
         }
      }
   }

   public enum Subsystem {
      case Default
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
         case .Default    : return "ua.com.wavelabs.default"
         case .Network   : return "NET"
         case .Data      : return "DAT"
         case .Model     : return "MOD"
         case .View      : return "VIE"
         case .Controller : return "CTL"
         case .Media     : return "ua.com.wavelabs.media"
         case .System       : return "SYS"
         case .Delegate  : return "DLG"
         }
      }
   }

   private let oslog: OSLog

   // MARK: Init / Deinit

   public init(subsystem: Subsystem, category: Category) {
      oslog = OSLog(subsystem: subsystem.stringValue, category: category.stringValue)
   }

   // MARK: Private

   private func log<T>(message: T, level: OSLogType, function: String, file: String, line: Int32) {
      let msg = "\(message) → \(function) ⋆ \(file.lastPathComponent):\(line)"
      switch level {
      case OSLogType.default:
         log_public(oslog, .default, msg)
      case OSLogType.debug:
         log_public(oslog, .debug, msg)
      case OSLogType.info:
         log_public(oslog, .info, msg)
      case OSLogType.error:
         log_public(oslog, .error, msg)
      case OSLogType.fault:
         log_public(oslog, .fault, msg)
      default:
         log_public(oslog, .default, msg)
      }
   }

   // MARK: - Public

   public func marker(_ title: String) {
      log_public(oslog, .debug, " ––––– ⋆ " + title)
   }

   public func initialize(function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: "+++", level: .debug, function: function, file: file, line: line)
   }

   public func deinitialize(function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: "~~~", level: .debug, function: function, file: file, line: line)
   }

   public func fault<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: message, level: .fault, function: function, file: file, line: line)
   }

   public func error<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: message, level: .error, function: function, file: file, line: line)
   }

   public func info<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: message, level: .info, function: function, file: file, line: line)
   }

   public func debug<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: message, level: .debug, function: function, file: file, line: line)
   }

   public func `default`<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      log(message: message, level: .default, function: function, file: file, line: line)
   }

   public func fault<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                     file: String = #file, line: Int32 = #line) {
      guard expression() else { return }
      log(message: message, level: .fault, function: function, file: file, line: line)
   }

   public func error<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                     file: String = #file, line: Int32 = #line) {
      guard expression() else { return }
      log(message: message, level: .error, function: function, file: file, line: line)
   }

   public func info<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                    file: String = #file, line: Int32 = #line) {
      guard expression() else { return }
      log(message: message, level: .info, function: function, file: file, line: line)
   }

   public func debug<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                     file: String = #file, line: Int32 = #line) {
      guard expression() else { return }
      log(message: message, level: .debug, function: function, file: file, line: line)
   }

   public func `default`<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                         file: String = #file, line: Int32 = #line) {
      guard expression() else { return }
      log(message: message, level: .default, function: function, file: file, line: line)
   }
}
