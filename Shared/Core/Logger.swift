/// File: Logger.swift
/// Project: WaveLabs
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation

private let globalLogger = Logger()

extension g {
   public static var log: Logger {
      return globalLogger
   }
}

private let loggingQueue = DispatchQueue(label: "ua.com.wavelabs.LoggingQueue", qos: .utility)

/// Sample usage:
///~~~
///private lazy var log: Logger = Logger(sender: self, context: .Context)
///~~~
public struct Logger {

   public enum Context {
      case Global
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
         case .Global		 : return "GLB"
         case .Network	 : return "NET"
         case .Data		 : return "DAT"
         case .Model		 : return "MOD"
         case .View		 : return "VIE"
         case .Controller : return "CTL"
         case .Media		 : return "MED"
         case .System		 : return "SYS"
         case .Delegate	 : return "DLG"
         }
      }
   }

   private enum Level {
      case Error
      case Warn
      case Info
      case Debug
      case Verbose
      static var allLevels: [Level] {
         return [.Verbose, .Debug, .Info, .Warn, .Error]
      }
      var stringValue: String {
         switch self {
         case .Error:	 return "E"
         case .Warn:	 return "W"
         case .Info:	 return "I"
         case .Debug:	 return "D"
         case .Verbose: return "V"
         }
      }
   }

   private struct SenderProperties {
      var pointerAddress: String
      var typeName: String
   }

   private struct LoggerPropertiesInternal {
      var context: Context
   }

   public enum MessageFilter: CustomReflectable {

      case AllMessages
      case InitDeinitMethodsOnly
      case AllExceptInitDeinitMethods

      fileprivate var shouldLogInitDeinitMethods: Bool {
         return self == .AllMessages || self == .InitDeinitMethodsOnly
      }

      fileprivate var shouldLogMessage: Bool {
         return self == .AllMessages || self == .AllExceptInitDeinitMethods
      }

      public static func from(string value: String) -> MessageFilter {
         switch value {
         case AllMessages.stringValue: return AllMessages
         case InitDeinitMethodsOnly.stringValue: return InitDeinitMethodsOnly
         case AllExceptInitDeinitMethods.stringValue: return AllExceptInitDeinitMethods
         default: return AllMessages
         }
      }

      var stringValue: String {
         switch self {
         case .AllMessages: return "AllMessages"
         case .InitDeinitMethodsOnly: return "InitDeinitMethodsOnly"
         case .AllExceptInitDeinitMethods: return "AllExceptInitDeinitMethods"
         }
      }

      public var customMirror: Mirror {
         let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("value", stringValue))
         return Mirror(self, children: children)
      }
   }

   public class Properties {
      private var logAsynchronouslyStorage = WriteSynchronizedProperty(true)
      public var logAsynchronously: Bool {
         get { return logAsynchronouslyStorage.value }
         set { logAsynchronouslyStorage.value = newValue }
      }
      private var logMessageFilterStorage = WriteSynchronizedProperty(MessageFilter.AllMessages)
      public var logMessageFilter: MessageFilter {
         get { return logMessageFilterStorage.value }
         set { logMessageFilterStorage.value = newValue }
      }
   }

   private var senderProperties: SenderProperties?
   private var loggerProperties: LoggerPropertiesInternal
   public static var sharedProperties: Properties {
      return _sharedLoggerProperties
   }
   private static var _sharedLoggerProperties = Properties()
   private static let dateFormatter = g.configure(DateFormatter()) {
      $0.dateFormat = "HH:mm:ss.SSSS"
   }

   #if DEBUG
   static var debuggingCallabck: ((String) -> Void)?
   #endif

   // MARK:

	/// - parameter sender: Logging source. **Note** Used only to retrieve properties without keeping references.
	public init(sender: AnyObject? = nil, context: Context = .Global) {
		if let senderValue = sender {
			var componentNames = g.string(fromClass: type(of: senderValue)).components(separatedBy: ".")
			if componentNames.count > 1 {
				componentNames.removeFirst()
			}
			let senderName = componentNames.joined(separator: ".")
			senderProperties = SenderProperties(pointerAddress: String(format: "%p", g.pointerAddress(of: senderValue)),
			                                    typeName: senderName)
		}
		loggerProperties = LoggerPropertiesInternal(context: context)
	}

   // MARK: Private

   // swiftlint:disable:next function_parameter_count
   private static func format<T>(message: T, level: Level, context: Context, function: String, file aFile: String,
                              line: Int32, typeName aTypeName: String?, objectPointerAddress: String?) -> String {
      let prefix = "\(level.stringValue):\(context.stringValue)"
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

   private static func executeBlock(block: @escaping (Void) -> Void) {
      if Logger.sharedProperties.logAsynchronously {
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
      func writeMessageToOutput() {
         if let buffer = message.cString(using: String.Encoding.utf8) {
            puts(buffer)
         } else {
            print(message)
         }
         // fflush(stdout)
      }
      #if DEBUG
         if let cb = debuggingCallabck {
            cb(message)
         } else {
            writeMessageToOutput()
         }
      #else
         writeMessageToOutput()
      #endif
   }

   // MARK: - Public

   public func marker(_ marker: String) {
      Logger.log(marker: marker)
   }

   public func text(_ text: String) {
      Logger.log(text: text)
   }

   public func initialize(function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogInitDeinitMethods else {
         return
      }
      Logger.log(message: "{+++}", level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func deinitialize(function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogInitDeinitMethods else {
         return
      }
      Logger.log(message: "{~~~}", level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func error<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Error, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func warn<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Warn, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func info<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Info, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func debug<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Debug, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func verbose<T>(_ message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage else {
         return
      }
      Logger.log(message: message, level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   // MARK:
   public func error<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                          file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage && expression() else {
         return
      }
      Logger.log(message: message, level: .Error, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func warn<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                         file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage && expression() else {
         return
      }
      Logger.log(message: message, level: .Warn, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func info<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                         file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage && expression() else {
         return
      }
      Logger.log(message: message, level: .Info, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func debug<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                          file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage && expression() else {
         return
      }
      Logger.log(message: message, level: .Debug, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }

   public func verbose<T>(_ message: T, if expression: @autoclosure() -> Bool, function: String = #function,
                            file: String = #file, line: Int32 = #line) {
      guard Logger.sharedProperties.logMessageFilter.shouldLogMessage && expression() else {
         return
      }
      Logger.log(message: message, level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
                 typeName: senderProperties?.typeName, objectPointerAddress: senderProperties?.pointerAddress)
   }
}
