//
//  String.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

// NSString bindings
public extension String {

   public func appending(pathComponent str: String) -> String {
      return (self as NSString).appendingPathComponent(str)
   }
   public var pathExtension: String {
      return (self as NSString).pathExtension
   }
   public var deletingPathExtension: String {
      return (self as NSString).deletingPathExtension
   }
   public func appending(pathExtension str: String) -> String? {
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

   public var uppercaseFirstCharacterString: String {
      if characters.count > 0 {
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
   public func clip(toLength length: Int) -> String {
      if length < 4 || characters.count < length {
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
   public var OSTypeValue: OSType {
      let chars = utf8
      var result: UInt32 = 0
      for aChar in chars {
         result = result << 8 + UInt32(aChar)
      }
      return result
   }
   // swiftlint:enable variable_name

   public var componentsSeparatedByNewline: [String] {
      return components(separatedBy: CharacterSet.newlines)
   }
}
