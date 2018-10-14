//
//  Dictionary.swift
//  mcFoundation
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension Dictionary {

   public func hasKey(_ key: Key) -> Bool {
      return keys.contains(key)
   }

   public func valueForRequiredKey<T>(_ key: Key) throws -> T {
      guard let existingValue = self[key] else {
         throw NSError.Dictionary.Key.requiredKeyIsMissed(key: "\(key)")
      }
      guard let resultValue = existingValue as? T else {
         throw NSError.Dictionary.Key.requiredKeyHasWrongType(key: "\(key)",
                                                              type: String(describing: type(of: existingValue)))
      }
      return resultValue
   }

   public func valueForOptionalKey<T>(_ key: Key) -> T? {
      guard let existingValue = self[key] else {
         return nil
      }
      guard let resultValue = existingValue as? T else {
         return nil
      }
      return resultValue
   }

   public func string(forKey: Key) -> String? {
      return valueForOptionalKey(forKey)
   }

   public func bool(forKey: Key) -> Bool? {
      return valueForOptionalKey(forKey)
   }

   public func url(forKey: Key) -> URL? {
      if let stringValue = string(forKey: forKey) {
         return URL(string: stringValue)
      } else {
         return nil
      }
   }

   public func string(forKeyPath: String) -> String? {
      return (self as NSDictionary).string(forKeyPath: forKeyPath)
   }

   public func int(forKeyPath: String) -> Int? {
      return (self as NSDictionary).int(forKeyPath: forKeyPath)
   }
}

extension Dictionary {

   @discardableResult
   public mutating func update(pair: (Key, Value)) -> Value? {
      return updateValue(pair.1, forKey: pair.0)
   }

   public init(_ pairs: [Element]) {
      self.init()
      for (key, value) in pairs {
         self[key] = value
      }
   }

   public func mapElements<OutKey, OutValue>(transform: (Element) throws -> (OutKey, OutValue)) rethrows -> [OutKey: OutValue] {
      return [OutKey: OutValue](try map(transform))
   }

   public func filterElements(includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
      return Dictionary(try filter(includeElement))
   }
}

extension Dictionary where Key == AnyHashable, Value == Any {

   public static func readPlist(fromURL plistURL: URL) throws -> [AnyHashable: Any] {
      guard let plist = NSDictionary(contentsOf: plistURL) else {
         throw NSError.Dictionary.IO.unableToReadFromURL(plistURL)
      }
      guard let result = plist as? [AnyHashable: Any] else {
         throw NSError.Dictionary.Value.unexpectedType(expected: [AnyHashable: Any].self, observed: type(of: plist))
      }
      return result
   }

   public func writePlistToFile(path: String, atomically: Bool) throws {
      if (self as NSDictionary).write(toFile: path, atomically: atomically) == false {
         throw NSError.Dictionary.IO.unableToWriteToFile(path)
      }
   }
}

// MARK: - Functions

// Immutable
public func + <K, V>(left: [K: V], right: [K: V]?) -> [K: V] {
   guard let right = right else { return left }
   return left.reduce(right) {
      var new = $0 as [K: V]
      new.updateValue($1.1, forKey: $1.0)
      return new
   }
}

// Mutable
public func += <K, V>(left: inout [K: V], right: [K: V]?) {
   guard let right = right else { return }
   right.forEach { pair in
      left.updateValue(pair.value, forKey: pair.key)
   }
}

// MARK: - NSError

extension NSError { struct Dictionary {} }
extension NSError.Dictionary {

   enum Key: Swift.Error {
      case requiredKeyIsMissed(key: String)
      case requiredKeyHasWrongType(key: String, type: String)
   }

   enum Value: Swift.Error {
      case unexpectedType(expected: Any.Type, observed: Any.Type)
   }

   enum IO: Swift.Error { // swiftlint:disable:this type_name
      case unableToWriteToFile(String)
      case unableToReadFromURL(URL)
   }
}

extension NSError.Dictionary.Key: LocalizedError, CustomStringConvertible {

   var errorDescription: String? {
      return description
   }

   var description: String {
      switch self {
      case .requiredKeyHasWrongType(let key, let type):
         return "Wrong type: key=\(key); type=\(type)"
      case .requiredKeyIsMissed(let key):
         return "Missed key: key=\(key)"
      }
   }
}
