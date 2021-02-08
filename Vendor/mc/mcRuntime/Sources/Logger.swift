//
//  Logger.swift
//  Decode
//
//  Created by Vlad Gorlov on 01.01.21.
//

import Foundation

open class Logger {

   public enum Format: Int, CaseIterable {
      case short, middle, long
   }

   public enum Level: Int, Comparable, CaseIterable {
      case error, warning, info, debug, verbose
      public static func < (lhs: Logger.Level, rhs: Logger.Level) -> Bool {
         return lhs.rawValue < rhs.rawValue
      }
      public var stringValue: String {
         switch self {
         case .debug:
            return "debug"
         case .error:
            return "error"
         case .info:
            return "info"
         case .verbose:
            return "verbose"
         case .warning:
            return "warning"
         }
      }
      public var codeValue: String {
         switch self {
         case .debug:
            return "D"
         case .error:
            return "E"
         case .info:
            return "I"
         case .verbose:
            return "V"
         case .warning:
            return "W"
         }
      }

      public var symbol: String {
         switch self {
         case .error:
            return "‼️"
         case .info:
            return "✅"
         case .verbose, .debug:
            return "**"
         case .warning:
            return "⚠️"
         }
      }

      public init?(stringValue: String) {
         let matches = Self.allCases.filter { $0.stringValue == stringValue }
         if let first = matches.first {
            self = first
         } else {
            return nil
         }
      }
   }

   public static var loggerType: Logger.Type = Logger.self

   public static var level = Level.info
   public static var id = "App"
   public static var format = Format.long

   public static func getLogger(_ type: Any.Type) -> Logger {
      return loggerType.init(String(describing: type))
   }

   public static func getLogger(_ name: String) -> Logger {
      return loggerType.init(name)
   }

   public let name: String

   public required init(_ name: String) {
      self.name = name
   }

   open func initialize(function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .verbose else {
         return
      }
      log(level: .verbose, category: name, message: "(Memory) +++", function: function, file: file, line: line, dso: dso)
   }

   open func deinitialize(function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .verbose else {
         return
      }
      log(level: .verbose, category: name, message: "(Memory) ~~~", function: function, file: file, line: line, dso: dso)
   }

   open func verbose(_ message: String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .verbose else {
         return
      }
      log(level: .verbose, category: name, message: message, function: function, file: file, line: line, dso: dso)
   }

   open func debug(_ message: String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .debug else {
         return
      }
      log(level: .debug, category: name, message: message, function: function, file: file, line: line, dso: dso)
   }

   open func info(_ message: String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .info else {
         return
      }
      log(level: .info, category: name, message: message, function: function, file: file, line: line, dso: dso)
   }

   open func warning(_ message: String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .warning else {
         return
      }
      log(level: .warning, category: name, message: message, function: function, file: file, line: line, dso: dso)
   }

   open func error(_ message: String, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      guard Self.level >= .error else {
         return
      }
      log(level: .error, category: name, message: message, function: function, file: file, line: line, dso: dso)
   }

   open func error(_ error: Error, function: StaticString = #function, file: StaticString = #file, line: UInt = #line, dso: UnsafeRawPointer? = #dsohandle) {
      self.error(String(describing: error), function: function, file: file, line: line, dso: dso)
   }

   open func format(message: String, level: Level, function: StaticString, file: StaticString, line: UInt) -> String {
      let filename = ("\(file)" as NSString).lastPathComponent
      let location = "\(filename):\(line)"
      let id = "[\(Self.id)/\(name)]"
      let level = "[\(level.codeValue)] \(level.symbol)"
      let msg: String
      switch Self.format {
      case .short:
         msg = "\(level) \(location) → \(message)"
      case .middle:
         msg = "\(level) \(id) \(location) → \(message)"
      case .long:
         msg = "\(level) \(id) \(location) ⋆ \(function) → \(message)"
      }
      return msg
   }

   open func log(level: Level, category: String, message: String,
                    function: StaticString, file: StaticString, line: UInt, dso: UnsafeRawPointer?) {
      let message = format(message: message, level: level, function: function, file: file, line: line)
      log(level: level, message: message, category: category, dso: dso)
   }

   open func log(level: Level, message: String, category: String, dso: UnsafeRawPointer?) {
      print(message)
   }
}
