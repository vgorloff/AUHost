/// File: Logger.swift
/// Project: WLCore
/// Author: Created by Vlad Gorlov on 29.01.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation

private let loggingQueue = dispatch_queue_create("ua.com.wavelabs.LoggingQueue", DISPATCH_QUEUE_SERIAL)

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
		public var logAsynchroniously = Property(true)
		public var logMessageFilter = Property(MessageFilter.AllMessages)
	}

	private var senderProperties: SenderProperties
	private var loggerProperties: LoggerPropertiesInternal
	public static var sharedLoggerProperties: LoggerProperties {
		return _sharedLoggerProperties
	}
	private static var _sharedLoggerProperties = LoggerProperties()
	private static let dateFormatter: NSDateFormatter = {
		let f = NSDateFormatter()
		f.dateFormat = "HH:mm:ss.SSSS"
		return f
	}()

	// MARK: -
	// -param sender: Logging source. **Note** Used only to retrieve properties and immediately releases.
	public init(sender: AnyObject, context: Context = .Global) {
		senderProperties = SenderProperties(pointerAddress: String(format: "%p", pointerAddressOf(sender)),
			typeName: String(sender.dynamicType))
		loggerProperties = LoggerPropertiesInternal(context: context)
	}

	// MARK: - Private

	// swiftlint:disable:next function_parameter_count
	private static func formatMessage<T>(message: T, level: Level, context: Context, function: String, file aFile: String,
		line: Int32, typeName aTypeName: String?, objectPointerAddress: String?) -> String {
			let prefix = "\(level.rawValue):\(context.rawValue)"
			let location = "\(aFile.lastPathComponent):\(line) ⋆ \(function.clipToLength(42))"
			var fullPrefix = "\(prefix) ⋆ \(location)"
			if let typeName = aTypeName, let pointer = objectPointerAddress {
				fullPrefix = "\(prefix) ⋆ \(pointer) \(typeName.clipToLength(32)) ⋆ \(location)"
			}
			return "\(fullPrefix) → \(message)"
	}

	// swiftlint:disable:next function_parameter_count
	private static func logMessage<T>(message: T, level: Level, context: Context, function: String, file: String,
		line: Int32, typeName: String? = nil, objectPointerAddress: String? = nil) {
			executeBlock {
				let message = formatMessage(message, level: level, context: context, function: function, file: file, line: line,
					typeName: typeName, objectPointerAddress: objectPointerAddress)
				let datePrefix = dateFormatter.stringFromDate(NSDate())
				Logger.logMessage("\(datePrefix) \(message)")
			}
	}

	private static func executeBlock(block: dispatch_block_t) {
		if Logger.sharedLoggerProperties.logAsynchroniously.value {
			dispatch_async(loggingQueue, block)
		} else {
			dispatch_sync(loggingQueue, block)
		}
	}

	private static func logMarker(name: String) {
		executeBlock {
			let dateString = dateFormatter.stringFromDate(NSDate())
			let msg = dateString + " ––––– ⋆ " + name
			Logger.logMessage(msg)
		}
	}

	private static func logText(text: String) {
		executeBlock {
			Logger.logMessage(text)
		}
	}

	private static func logMessage(message: String) {
		if let buffer = message.cStringUsingEncoding(NSUTF8StringEncoding) {
			puts(buffer)
		} else {
			print(message)
		}
		// fflush(stdout)
	}

	// MARK: - Public

	public func logMarker(name: String) {
		Logger.logMarker(name)
	}

	public func logText(text: String) {
		Logger.logText(text)
	}

	public func logInit(function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
			return
		}
		Logger.logMessage("{+++}", level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logDeinit(function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
			return
		}
		Logger.logMessage("{~~~}", level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logError<T>(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
			return
		}
		Logger.logMessage(message, level: .Error, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logWarn<T>(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
			return
		}
		Logger.logMessage(message, level: .Warn, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logInfo<T>(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
			return
		}
		Logger.logMessage(message, level: .Info, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logDebug<T>(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
			return
		}
		Logger.logMessage(message, level: .Debug, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logVerbose<T>(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
			return
		}
		Logger.logMessage(message, level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	// MARK: -
	public func logErrorIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
		file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
			return
		}
		Logger.logMessage(message, level: .Error, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logWarnIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
		file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
			return
		}
		Logger.logMessage(message, level: .Warn, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logInfoIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
		file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
			return
		}
		Logger.logMessage(message, level: .Info, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logDebugIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
		file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
			return
		}
		Logger.logMessage(message, level: .Debug, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}

	public func logVerboseIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
		file: String = #file, line: Int32 = #line) {
		guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
			return
		}
		Logger.logMessage(message, level: .Verbose, context: loggerProperties.context, function: function, file: file, line: line,
			typeName: senderProperties.typeName, objectPointerAddress: senderProperties.pointerAddress)
	}


}

// MARK: - Global
public func logMarker(name: String) {
	Logger.logMarker(name)
}

public func logText(text: String) {
	Logger.logText(text)
}

public func logInit(function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
		return
	}
	Logger.logMessage("+++", level: .Verbose, context: .Global, function: function, file: file, line: line)
}

public func logDeinit(function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogInitDeinitMethods else {
		return
	}
	Logger.logMessage("~~~", level: .Verbose, context: .Global, function: function, file: file, line: line)
}

public func logError<T> (message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
		return
	}
	Logger.logMessage(message, level: .Error, context: .Global, function: function, file: file, line: line)
}

public func logWarn<T>	(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
		return
	}
	Logger.logMessage(message, level: .Warn, context: .Global, function: function, file: file, line: line)
}

public func logInfo<T>	(message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
		return
	}
	Logger.logMessage(message, level: .Info, context: .Global, function: function, file: file, line: line)
}

public func logDebug<T> (message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
		return
	}
	Logger.logMessage(message, level: .Debug, context: .Global, function: function, file: file, line: line)
}

public func logVerbose<T> (message: T, function: String = #function, file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage else {
		return
	}
	Logger.logMessage(message, level: .Verbose, context: .Global, function: function, file: file, line: line)
}

// MARK: -
public func logErrorIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
	file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
		return
	}
	Logger.logMessage(message, level: .Error, context: .Global, function: function, file: file, line: line)
}

public func logWarnIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
	file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
		return
	}
	Logger.logMessage(message, level: .Warn, context: .Global, function: function, file: file, line: line)
}

public func logInfoIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
	file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
		return
	}
	Logger.logMessage(message, level: .Info, context: .Global, function: function, file: file, line: line)
}

public func logDebugIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
	file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
		return
	}
	Logger.logMessage(message, level: .Debug, context: .Global, function: function, file: file, line: line)
}

public func logVerboseIf<T>(@autoclosure expression: () -> BooleanType, _ message: T, function: String = #function,
	file: String = #file, line: Int32 = #line) {
	guard Logger.sharedLoggerProperties.logMessageFilter.value.shouldLogMessage && expression().boolValue else {
		return
	}
	Logger.logMessage(message, level: .Verbose, context: .Global, function: function, file: file, line: line)
}
