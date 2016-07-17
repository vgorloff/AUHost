/// File: Logger.swift
/// Project: WaveLabs
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation

private let loggingQueue = DispatchQueue(label: "ua.com.wavelabs.LoggingQueue", attributes: .serial)

/// Sample usage:
///~~~
///private lazy var log: Logger = Logger(sender: self, context: .Context)
///~~~
public struct Logger {

   public enum Context: String {
      case Global		 = "GLB"
      case Network	 = "NET"
      case Data		 = "DAT"
      case Model		 = "MOD"
      case View		 = "VIE"
      case Controller = "CTL"
      case Media		 = "MED"
      case System		 = "SYS"
      case Delegate	 = "DLG"
   }

   private enum Level: String {
      case Error	 = "E"
      case Warn	 = "W"
      case Info	 = "I"
      case Debug	 = "D"
      case Verbose = "V"
      static var allLevels: [Level] {
         return [.Verbose, .Debug, .Info, .Warn, .Error]
      }
   }

   private struct SenderProperties {
      var pointerAddress: String
      var typeName: String
   }

   private struct LoggerPropertiesInternal {
      var context: Context
   }

   public enum MessageFilter: String {
      case AllMessages = "AllMessages"
      case InitDeinitMethodsOnly = "InitDeinitMethodsOnly"
      case AllExceptInitDeinitMethods = "AllExceptInitDeinitMethods"
      private var shouldLogInitDeinitMethods: Bool {
         return self == .AllMessages || self == .InitDeinitMethodsOnly
      }
      private var shouldLogMessage: Bool {
         return self == .AllMessages || self == .AllExceptInitDeinitMethods
      }
      public static func fromRaw(rawValue: String) -> MessageFilter {
         return MessageFilter(rawValue: rawValue) ?? .AllMessages
      }
   }

   public struct LoggerProperties {
      public var logAsynchronously = Property(true)
      public var logMessageFilter = Property(MessageFilter.AllMessages)
   }

   private var senderProperties: SenderProperties
   private var loggerProperties: LoggerPropertiesInternal
   public static var sharedLoggerProperties: LoggerProperties {
      return _sharedLoggerProperties
   }
   private static var _sharedLoggerProperties = LoggerProperties()
   private static let dateFormatter: DateFormatter = {
      let f = DateFormatter()
      f.dateFormat = "HH:mm:ss.SSSS"
      return f
   }()

   // MARK:

   // -param sender: Logging source. **Note** Used only to retrieve properties and immediately releases.
   public init(sender: AnyObject, context: Context = .Global) {
      senderProperties = SenderProperties(pointerAddress: String(format: "%p", pointerAddress(of: sender)),
                                          typeName: String(sender.dynamicType))
      loggerProperties = LoggerPropertiesInternal(context: context)
   }

   // MARK: Private

   // swiftlint:disable:next function_parameter_count
   private static func format<T>(message: T, level: Level, context: Context, function: String, file aFile: String,
                              line: Int32, typeName aTypeName: String?, objectPointerAddress: String?) -> String {
      let prefix = "\(level.rawValue):\(context.rawValue)"
      let location = "\(aFile.lastPathComponent):\(line) ⋆ \(function.clip(toLength: 42))"
      let defaultMessage = "\(prefix) ⋆ \(location) → \(message)"
      guard let typeName = aTypeName else {
			return defaultMessage
      }
      guard let pointer = objectPointerAddress else {
			return defaultMessage
      }
      return "\(prefix) ⋆ \(pointer) \(typeName.clip(toLength: 32)) ⋆ \(location) → \(message)"
   }

   // swiftlint:disable:next function_parameter_count
   private static func log<T>(message: T, level: Level, context: Context, function: String, file: String,
                           line: Int32, typeName: String? = nil, objectPointerAddress: String? = nil) {
      executeBlock {
         let message = format(message: message, level: level, context: context, function: function, file: file, line: line,
                              typeName: typeName, objectPointerAddress: objectPointerAddress)
         let datePrefix = dateFormatter.string(from: Date())
         Logger.log(message: "\(datePrefix) \(message)")
      }
   }

   private static func executeBlock(block: (Void) -> Void) {
      if Logger.sharedLoggerProperties.logAsynchronously.value { // TODO: Avoid locking
         loggingQueue.async(execute: block)
      } else {
         loggingQueue.sync(execute: block)
      }
   }

   private static func log(marker name: String) {
      executeBlock {
         let dateString = dateFormatter.string(from: Date())
         let msg = dateString + " ––––– ⋆ " + name
         Logger.log(message: msg)
      }
   }

   private static func log(text: String) {
      executeBlock {
         Logger.log(message: text)
      }
   }

   private static func log(message: String) {
      if let buffer = message.cString(using: String.Encoding.utf8) {
         puts(buffer)
      } else {
         print(message)
      }
      // fflush(stdout)
   }

   // MARK: - Public

   public func log(marker: String) {
      Logger.log(marker: marker)
   }

   public func log(text: String) {
      Logger.log(text: text)
   }

   public func logInit(function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
         return
      }
      Logger.log(message: "{+++}", level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logDeinit(function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
         return
      }
      Logger.log(message: "{~~~}", level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logError<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Error, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logWarn<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Warn, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logInfo<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Info, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logDebug<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Debug, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logVerbose<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   // MARK:
   public func logErrorIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                          file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
         return
      }
      Logger.log(message: message, level: .Error, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logWarnIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                         file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
         return
      }
      Logger.log(message: message, level: .Warn, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logInfoIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                         file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
         return
      }
      Logger.log(message: message, level: .Info, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logDebugIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                          file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
         return
      }
      Logger.log(message: message, level: .Debug, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }

   public func logVerboseIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                            file: String = #file, line: Int32 = #line) {
      guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
         return
      }
      Logger.log(message: message, level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
   }


}

// MARK: - Global
public func log(marker: String) {
   Logger.log(marker: marker)
}

public func log(text: String) {
   Logger.log(text: text)
}

public func logInit(function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
      return
   }
   Logger.log(message: "+++", level: .Verbose, context: .Global, function: function, file: file, line: line)
}

public func logDeinit(function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
      return
   }
   Logger.log(message: "~~~", level: .Verbose, context: .Global, function: function, file: file, line: line)
}

public func logError<T> (_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
      return
   }
   Logger.log(message: message, level: .Error, context: .Global, function: function, file: file, line: line)
}

public func logWarn<T>	(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
      return
   }
   Logger.log(message: message, level: .Warn, context: .Global, function: function, file: file, line: line)
}

public func logInfo<T>	(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
      return
   }
   Logger.log(message: message, level: .Info, context: .Global, function: function, file: file, line: line)
}

public func logDebug<T> (_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
      return
   }
   Logger.log(message: message, level: .Debug, context: .Global, function: function, file: file, line: line)
}

public func logVerbose<T> (_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
      return
   }
   Logger.log(message: message, level: .Verbose, context: .Global, function: function, file: file, line: line)
}

// MARK: -
public func logErrorIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                       file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
      return
   }
   Logger.log(message: message, level: .Error, context: .Global, function: function, file: file, line: line)
}

public func logWarnIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                      file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
      return
   }
   Logger.log(message: message, level: .Warn, context: .Global, function: function, file: file, line: line)
}

public func logInfoIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                      file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
      return
   }
   Logger.log(message: message, level: .Info, context: .Global, function: function, file: file, line: line)
}

public func logDebugIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                       file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
      return
   }
   Logger.log(message: message, level: .Debug, context: .Global, function: function, file: file, line: line)
}

public func logVerboseIf<T>( expression: @autoclosure() -> Boolean, _ message: T, function: String = #function,
                         file: String = #file, line: Int32 = #line) {
   guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
      return
   }
   Logger.log(message: message, level: .Verbose, context: .Global, function: function, file: file, line: line)
}
