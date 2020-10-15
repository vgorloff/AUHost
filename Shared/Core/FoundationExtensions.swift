//
//  FoundationExtensions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension DateFormatter {
   static func localizedStringFromDate(date: Date, dateFormat: String) -> String {
      let f = DateFormatter()
      f.dateFormat = dateFormat
      return f.string(from: date)
   }
}

public extension Pipe {
   
   func readIntoString() -> String? {
      let data = fileHandleForReading.readDataToEndOfFile()
      if data.count > 0 {
         if let s = String(data: data, encoding: String.Encoding.utf8) {
            return s.trimmingCharacters(in: .newlines)
         }
      }
      return nil
   }
   
}

#if os(OSX)

public extension Process {
   static func findExecutablePath(_ executableName: String) -> String? {
      if executableName.isEmpty {
         return nil
      }
      let task = Process()
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

public extension OperationQueue {
   
   struct UserInteractive {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .userInteractive
         q.name = name
         return q
      }
   }
   
   struct UserInitiated {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .userInitiated
         q.name = name
         return q
      }
   }
   
   struct Utility {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .utility
         q.name = name
         return q
      }
   }
   
   struct Background {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .background
         q.name = name
         return q
      }
   }
   
   struct Default {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .default
         q.name = name
         return q
      }
   }
   
   struct NonConcurrent {
      public static func userInteractive(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInteractive.nonConcurrent(name: name)
      }
      public static func userInitiated(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInitiated.nonConcurrent(name: name)
      }
      public static func utility(name: String? = nil) -> OperationQueue {
         return OperationQueue.Utility.nonConcurrent(name: name)
      }
      public static func background(name: String? = nil) -> OperationQueue {
         return OperationQueue.Background.nonConcurrent(name: name)
      }
      public static func `default`(name: String? = nil) -> OperationQueue {
         return OperationQueue.Default.nonConcurrent(name: name)
      }
   }
   
   struct Concurrent {
      public static func userInteractive(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInteractive.concurrent(name: name)
      }
      public static func userInitiated(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInitiated.concurrent(name: name)
      }
      public static func utility(name: String? = nil) -> OperationQueue {
         return OperationQueue.Utility.concurrent(name: name)
      }
      public static func background(name: String? = nil) -> OperationQueue {
         return OperationQueue.Background.concurrent(name: name)
      }
      public static func `default`(name: String? = nil) -> OperationQueue {
         return OperationQueue.Default.concurrent(name: name)
      }
   }
   
}

public enum BundleError: Error {
   case missedURLForResource(resourceName: String, resourceExtension: String)
}

public extension Bundle {
   
   func urlForResource(resourceName: String, resourceExtension: String) throws -> URL {
      guard let url = url(forResource: resourceName, withExtension: resourceExtension) else {
         throw BundleError.missedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
      }
      return url
   }
}

public enum NSDictionaryError: Error {
   case unableToWriteToFile(String)
   case unableToReadFromURL(URL)
   case missedRequiredKey(String)
}

public extension NSDictionary {
   
   func hasKey<T: AnyObject>(key: T) -> Bool where T: Equatable {
      return allKeys.filter { element in return (element as? T) == key }.count == 1
   }
   func value<T>(forRequiredKey key: AnyObject) throws -> T {
      guard let value = object(forKey: key) as? T else {
         throw NSDictionaryError.missedRequiredKey(String(describing: key))
      }
      return value
   }
   
   func value<T>(forOptionalKey key: AnyObject) -> T? {
      return object(forKey: key) as? T
   }
   
   func value<T>(forOptionalKey key: String) -> T? {
      return object(forKey: key) as? T
   }
   
   func writePlistToFile(path: String, atomically: Bool) throws {
      if !write(toFile: path, atomically: atomically) {
         throw NSDictionaryError.unableToWriteToFile(path)
      }
   }
   static func readPlist(fromURL plistURL: URL) throws -> NSDictionary {
      guard let plist = NSDictionary(contentsOf: plistURL) else {
         throw NSDictionaryError.unableToReadFromURL(plistURL)
      }
      return plist
   }
}

public extension DispatchSemaphore {
   func wait( completion: () -> Void) {
      wait()
      completion()
   }
}

public extension DispatchQueue {
   
   static var Default: DispatchQueue =  .global(qos: .default)
   static var UserInteractive: DispatchQueue = .global(qos: .userInteractive)
   static var UserInitiated: DispatchQueue = .global(qos: .userInitiated)
   static var Utility: DispatchQueue = .global(qos: .utility)
   static let Background: DispatchQueue = .global(qos: .background)
   
   static func serial(label: String) -> DispatchQueue {
      return DispatchQueue(label: label)
   }
   
   func smartSync<T>(execute work: () throws -> T) rethrows -> T {
      if Thread.isMainThread {
         return try work()
      } else {
         return try sync(execute: work)
      }
   }
   
}

public enum FileManagerError: Error {
   case directoryIsNotAvailable(String)
   case regularFileIsNotAvailable(String)
   case canNotOpenFileAtPath(String)
   case executableNotFound(String)
}

public extension FileManager {
   
   class var applicationDocumentsDirectory: URL {
      let urls = self.default.urls(for: .documentDirectory, in: .userDomainMask)
      return urls.last!
   }
   
   func directoryExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileExists(atPath: path, isDirectory: &isDir)
      return isExists && isDir.boolValue
   }
   
   func regularFileExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileExists(atPath: path, isDirectory: &isDir)
      return isExists && !isDir.boolValue
   }
   
}

public extension URL {
   
   // Every element is a string in key=value format
   static func requestQuery(fromParameters elements: [String]) -> String {
      return elements.joined(separator: "&")
   }
}

public extension UserDefaults {
   
   func setDate(_ value: NSDate?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }
   
   func setString(_ value: String?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }
   
   func setBool(_ value: Bool?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }
   
   func setInteger(_ value: Int?, forKey key: String) {
      if let v = value {
         set(v, forKey: key)
      } else {
         removeObject(forKey: key)
      }
   }
   
   func boolValue(key: String) -> Bool? {
      if object(forKey: key) != nil {
         return bool(forKey: key)
      } else {
         return nil
      }
   }
   
   func integerValue(key: String) -> Int? {
      if object(forKey: key) != nil {
         return integer(forKey: key)
      } else {
         return nil
      }
   }
   
   func dateValue(key: String) -> NSDate? {
      return object(forKey: key) as? NSDate
   }
   
   func stringValue(key: String) -> String? {
      return string(forKey: key)
   }
}

public extension ProcessInfo {
   static var isUnderTesting: Bool {
      return NSClassFromString("XCTestCase") != nil
   }
}
