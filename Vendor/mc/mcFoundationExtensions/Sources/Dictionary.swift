//
//  Dictionary.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes

public class __DictionaryAsExisting<K: Hashable, V>: InstanceHolder<[K: V]> {

   public func string(forKeyPath: String) throws -> String {
      if let value = instance.string(forKeyPath: forKeyPath) {
         return value
      } else {
         throw DictionaryError.Key.requiredKeyIsMissed(key: forKeyPath)
      }
   }

   public func array<T>(forKeyPath: String) throws -> [T] {
      guard let value = (instance as NSDictionary).value(forKeyPath: forKeyPath) else {
         throw DictionaryError.Key.requiredKeyIsMissed(key: forKeyPath)
      }
      if let value = value as? [T] {
         return value
      } else {
         throw DictionaryError.Key.requiredKeyHasWrongType(key: forKeyPath, type: String(describing: type(of: value)))
      }
   }

   public func value<T>(forKey key: K) throws -> T {
      guard let existingValue = instance[key] else {
         throw DictionaryError.Key.requiredKeyIsMissed(key: "\(key)")
      }
      guard let resultValue = existingValue as? T else {
         throw DictionaryError.Key.requiredKeyHasWrongType(key: "\(key)",
                                                           type: String(describing: type(of: existingValue)))
      }
      return resultValue
   }
}

extension Dictionary {

   public var asExisting: __DictionaryAsExisting<Key, Value> {
      return __DictionaryAsExisting(instance: self)
   }

   public func hasKey(_ key: Key) -> Bool {
      return keys.contains(key)
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

   public func int(forKey: Key) -> Int? {
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

   public func value(forKeyPath: String) -> Any? {
      return (self as NSDictionary).value(forKeyPath: forKeyPath)
   }

   public func dictionary(forKeyPath: String) -> [AnyHashable: Any]? {
      return (self as NSDictionary).value(forKeyPath: forKeyPath) as? [AnyHashable: Any]
   }

   public mutating func setValue(_ value: Any, forKeyPath: String, keyPathSeparator: String = ".") {
      let components = forKeyPath.components(separatedBy: keyPathSeparator)
      var paths = components.filter { !$0.isEmpty }
      if components.count != paths.count {
         return
      }

      if paths.count == 1 {
         if let key = paths.first as? Key, let result = value as? Value {
            self[key] = result
         }
         return
      }

      var dictionary: [AnyHashable: Any] = self
      var mappings: [(String, [AnyHashable: Any])] = []

      var lastPath: String?
      while !paths.isEmpty {
         let path = paths.removeFirst()
         if paths.isEmpty {
            lastPath = path
         } else {
            if dictionary.hasKey(path) {
               if let value = dictionary[path] as? [AnyHashable: Any] {
                  dictionary = value
                  mappings.append((path, value))
               } else {
                  break
               }
            } else {
               let newValue: [AnyHashable: Any] = [:]
               mappings.append((path, newValue))
               dictionary = newValue
            }
         }
      }

      guard var path = lastPath else {
         return
      }

      var resultValue: [AnyHashable: Any]?
      for mapping in mappings.reversed() {
         var dict = mapping.1
         if let value = resultValue {
            dict[path] = value
         } else {
            dict[path] = value
         }
         resultValue = dict
         path = mapping.0
      }
      if let key = path as? Key, let result = resultValue as? Value {
         self[key] = result
      }
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
         throw DictionaryError.IO.unableToReadFromURL(plistURL)
      }
      guard let result = plist as? [AnyHashable: Any] else {
         throw DictionaryError.Value.unexpectedType(expected: [AnyHashable: Any].self, observed: type(of: plist))
      }
      return result
   }

   public func writePlist(toFile path: String, atomically: Bool) throws {
      if (self as NSDictionary).write(toFile: path, atomically: atomically) == false {
         throw DictionaryError.IO.unableToWriteToFile(path)
      }
   }

   /// Use this function only for debugging purpose.
   /// Usage: `po print(myDictionary.dump())`
   func dump() throws -> String {
      var options = JSONSerialization.WritingOptions.prettyPrinted
      if #available(OSX 10.13, watchOS 4.0, *) {
         options.insert(.sortedKeys)
      }
      let data = try JSONSerialization.data(withJSONObject: self, options: options)
      let result = String(data: data, encoding: .utf8) ?? "null"
      return result
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

public struct DictionaryError {

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

extension DictionaryError.Key: LocalizedError, CustomStringConvertible {

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
