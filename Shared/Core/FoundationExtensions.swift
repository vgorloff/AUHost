//
//  FoundationExtensions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

#if os(OSX)

public extension Task {
	public static func findExecutablePath(_ executableName: String) -> String? {
		if executableName.isEmpty {
			return nil
		}
		let task = Task()
		task.launchPath = "/bin/bash"
		task.arguments = ["-l", "-c", "which \(executableName)"]

		let outPipe = Pipe()
		task.standardOutput = outPipe

		task.launch()
		task.waitUntilExit()

		return outPipe.readIntoString()
	}
}

#endif

public extension DateFormatter {
	public static func localizedStringFromDate(date: Date, dateFormat: String) -> String {
		let f = DateFormatter()
		f.dateFormat = dateFormat
		return f.string(from: date)
	}
}


public extension Pipe {

   public func readIntoString() -> String? {
      let data = fileHandleForReading.readDataToEndOfFile()
      if data.count > 0 {
         if let s = String(data: data, encoding: String.Encoding.utf8) {
            return s.trimmingCharacters(in: CharacterSet.newlines)
         }
      }
      return nil
   }

}

public extension OperationQueue {

	public struct UserInteractive {
		public static func NonConcurrent(name: String? = nil) -> OperationQueue {
			let q = Concurrent(name: name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> OperationQueue {
			let q = OperationQueue()
			q.qualityOfService = .userInteractive
			q.name = name
			return q
		}
	}

	public struct UserInitiated {
		public static func NonConcurrent(name: String? = nil) -> OperationQueue {
			let q = Concurrent(name: name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> OperationQueue {
			let q = OperationQueue()
			q.qualityOfService = .userInitiated
			q.name = name
			return q
		}
	}

	public struct Utility {
		public static func NonConcurrent(name: String? = nil) -> OperationQueue {
			let q = Concurrent(name: name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> OperationQueue {
			let q = OperationQueue()
			q.qualityOfService = .utility
			q.name = name
			return q
		}
	}

	public struct Background {
		public static func NonConcurrent(name: String? = nil) -> OperationQueue {
			let q = Concurrent(name: name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> OperationQueue {
			let q = OperationQueue()
			q.qualityOfService = .background
			q.name = name
			return q
		}
	}

	public struct Default {
		public static func NonConcurrent(name: String? = nil) -> OperationQueue {
			let q = Concurrent(name: name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> OperationQueue {
			let q = OperationQueue()
			q.qualityOfService = .default
			q.name = name
			return q
		}
	}

	public struct NonConcurrent {
		public static func UserInteractive(name: String? = nil) -> OperationQueue {
			return OperationQueue.UserInteractive.NonConcurrent(name: name)
		}
		public static func UserInitiated(name: String? = nil) -> OperationQueue {
			return OperationQueue.UserInitiated.NonConcurrent(name: name)
		}
		public static func Utility(name: String? = nil) -> OperationQueue {
			return OperationQueue.Utility.NonConcurrent(name: name)
		}
		public static func Background(name: String? = nil) -> OperationQueue {
			return OperationQueue.Background.NonConcurrent(name: name)
		}
		public static func Default(name: String? = nil) -> OperationQueue {
			return OperationQueue.Default.NonConcurrent(name: name)
		}
	}

	public struct Concurrent {
		public static func UserInteractive(name: String? = nil) -> OperationQueue {
			return OperationQueue.UserInteractive.Concurrent(name: name)
		}
		public static func UserInitiated(name: String? = nil) -> OperationQueue {
			return OperationQueue.UserInitiated.Concurrent(name: name)
		}
		public static func Utility(name: String? = nil) -> OperationQueue {
			return OperationQueue.Utility.Concurrent(name: name)
		}
		public static func Background(name: String? = nil) -> OperationQueue {
			return OperationQueue.Background.Concurrent(name: name)
		}
		public static func Default(name: String? = nil) -> OperationQueue {
			return OperationQueue.Default.Concurrent(name: name)
		}
	}

}

// MARK:

public enum BundleError: ErrorProtocol {
	case MissedURLForResource(resourceName: String, resourceExtension: String)
}

public extension Bundle {

	public func urlForResource(resourceName: String, resourceExtension: String) throws -> NSURL {
		guard let url = urlForResource(resourceName, withExtension: resourceExtension) else {
			throw BundleError.MissedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
		}
		return url
	}
}

// MARK:

public enum NSDictionaryError: ErrorProtocol {
	case UnableToWriteToFile(String)
	case UnableToReadFromURL(NSURL)
}

public extension NSDictionary {

	public func hasKey<T: AnyObject where T: Equatable>(key: T) -> Bool {
		return allKeys.filter { element in return (element as? T) == key }.count == 1
	}
	public func writePlistToFile(path: String, atomically: Bool) throws {
		if !write(toFile: path, atomically: atomically) {
			throw NSDictionaryError.UnableToWriteToFile(path)
		}
	}
	public static func readPlistFromURL(plistURL: URL) throws -> NSDictionary {
		guard let plist = NSDictionary(contentsOf: plistURL) else {
			throw NSDictionaryError.UnableToReadFromURL(plistURL)
		}
		return plist
	}
}

// MARK:

public extension DispatchSemaphore {
  public func wait( completion: @noescape (Void) -> Void) {
    wait()
    completion()
  }
}

public extension DispatchQueue {

	public static var Default: DispatchQueue {
		return DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosDefault)
	}

	public static var UserInteractive: DispatchQueue {
		return DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosUserInteractive)
	}

	public static var UserInitiated: DispatchQueue {
		return DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosUserInitiated)
	}

	public static var Utility: DispatchQueue {
		return DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosUtility)
	}

	public static var Background: DispatchQueue {
		return DispatchQueue.global(attributes: DispatchQueue.GlobalAttributes.qosBackground)
	}

	public func smartSync<T>(execute work: @noescape () throws -> T) rethrows -> T {
		if Thread.isMainThread {
			return try work()
		} else {
			return try sync(execute: work)
		}
	}

}

// MARK:

public enum FileManagerError: ErrorProtocol {
	case DirectoryIsNotAvailable(String)
	case RegularFileIsNotAvailable(String)
	case CanNotOpenFileAtPath(String)
	case ExecutableNotFound(String)
}

public extension FileManager {

	public class var applicationDocumentsDirectory: NSURL {
		let urls = self.default.urlsForDirectory(.documentDirectory, inDomains: .userDomainMask)
		return urls[urls.count-1]
	}

	public func directoryExists(atPath path: String) -> Bool {
		var isDir = ObjCBool(false)
		let isExists = fileExists(atPath: path, isDirectory: &isDir)
		return isExists && isDir.boolValue
	}

	public func regularFileExists(atPath path: String) -> Bool {
		var isDir = ObjCBool(false)
		let isExists = fileExists(atPath: path, isDirectory: &isDir)
		return isExists && !isDir.boolValue
	}

}

public extension NSURL {

	// Every element is a string in key=value format
	public class func requestQueryFromParameters(elements: [String]) -> String {
		if elements.count > 0 {
			return elements[1..<elements.count].reduce(elements[0], combine: {$0 + "&" + $1})
		} else {
			return elements[0]
		}
	}
}

public extension UserDefaults {

	public func setDate(value: NSDate?, forKey key: String) {
		if let v = value {
			set(v, forKey: key)
		} else {
			removeObject(forKey: key)
		}
	}

	public func setString(value: String?, forKey key: String) {
		if let v = value {
			set(v, forKey: key)
		} else {
			removeObject(forKey: key)
		}
	}

	public func setBool(value: Bool?, forKey key: String) {
		if let v = value {
			set(v, forKey: key)
		} else {
			removeObject(forKey: key)
		}
	}

	public func setInteger(value: Int?, forKey key: String) {
		if let v = value {
			set(v, forKey: key)
		} else {
			removeObject(forKey: key)
		}
	}

	public func boolValue(key: String) -> Bool? {
		if let _ = object(forKey: key) {
			return bool(forKey: key)
		} else {
			return nil
		}
	}

	public func integerValue(key: String) -> Int? {
		if let _ = object(forKey: key) {
			return integer(forKey: key)
		} else {
			return nil
		}
	}

	public func dateValue(key: String) -> NSDate? {
		return object(forKey: key) as? NSDate
	}

	public func stringValue(key: String) -> String? {
		return string(forKey: key)
	}
}
