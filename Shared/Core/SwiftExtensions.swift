//
//  SwiftExtensions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

// NSString bindings
public extension String {
   
   func appending(pathComponent str: String) -> String {
      return (self as NSString).appendingPathComponent(str)
   }
   var pathExtension: String {
      return (self as NSString).pathExtension
   }
   var deletingPathExtension: String {
      return (self as NSString).deletingPathExtension
   }
   func appending(pathExtension str: String) -> String? {
      return (self as NSString).appendingPathExtension(str)
   }
   var lastPathComponent: String {
      return (self as NSString).lastPathComponent
   }
   var deletingLastPathComponent: String {
      return (self as NSString).deletingLastPathComponent
   }
   var expandingTildeInPath: String {
      return (self as NSString).expandingTildeInPath
   }
}

public extension String {
   
   var uppercaseFirstCharacterString: String {
      if count > 0 {
         let separationIndex = index(after: startIndex)
         let firstLetter = substring(to: separationIndex).uppercased()
         let capitalisedSentence = substring(from: separationIndex)
         return firstLetter + capitalisedSentence
      } else {
         return self
      }
   }
   
   /// - parameter length: Desired string length. Should be at least 4 characters.
   /// - returns: New string by replacing original string middle characters with ".."
   func clip(toLength length: Int) -> String {
      if length < 4 || count < length {
         return self
      }
      
      let rangeEnd = length / 2 - 1 // "- 1" represents one dot "."
      let rangeStart = length - 2 - rangeEnd // "- 2" represents two dots ".."
      let indexStart = index(startIndex, offsetBy: rangeStart)
      let indexEnd = index(endIndex, offsetBy: -rangeEnd)
      let range = indexStart ..< indexEnd
      var s = self
      s.replaceSubrange(range, with: "..")
      return s
   }
   
   // swiftlint:disable variable_name
   var OSTypeValue: OSType {
      let chars = utf8
      var result: UInt32 = 0
      for aChar in chars {
         result = result << 8 + UInt32(aChar)
      }
      return result
   }
   // swiftlint:enable variable_name
   
   var componentsSeparatedByNewline: [String] {
      return components(separatedBy: CharacterSet.newlines)
   }
}

public enum DictionaryError: Error {
   case missedRequiredKey(String)
}

public extension Dictionary {
   
   func value<T>(forRequiredKey key: Key) throws -> T {
      guard let value = self[key] as? T else {
         throw DictionaryError.missedRequiredKey(String(describing: key))
      }
      return value
   }
   
   func value<T>(forOptionalKey key: Key) -> T? {
      if let value = self[key] as? T {
         return value
      }
      return nil
   }
   
   func hasKey(_ key: Key) -> Bool {
      return Array(keys).filter { $0 == key }.count == 1
   }
   
}

extension Array {
   func element(at index: Index) -> Element? {
      if index < startIndex || index >= endIndex {
         return nil
      }
      return self[index]
   }
}

public extension ProcessInfo {
   
   struct Static {
      static var scriptFilePath: String?
   }
   
   /// Path to original script before compilation
   static var scriptFilePath: String? {
      get {
         return Static.scriptFilePath
      } set {
         Static.scriptFilePath = newValue
      }
   }
   
   static var executableFilePath: String {
      return scriptFilePath ?? ProcessInfo.processInfo.arguments[0]
   }
   
   static var executableFileName: String {
      return (scriptFilePath ?? ProcessInfo.processInfo.arguments[0]).lastPathComponent
   }
   
   static var executableDirectoryPath: String {
      return executableFilePath.deletingLastPathComponent
   }
   
}
