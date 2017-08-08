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

   public func appendingPathComponent(_ str: String) -> String {
      return (self as NSString).appendingPathComponent(str)
   }

   public var pathExtension: String {
      return (self as NSString).pathExtension
   }

   public var deletingPathExtension: String {
      return (self as NSString).deletingPathExtension
   }

   public func appendingPathExtension(_ str: String) -> String? {
      return (self as NSString).appendingPathExtension(str)
   }

   public var lastPathComponent: String {
      return (self as NSString).lastPathComponent
   }

   public var deletingLastPathComponent: String {
      return (self as NSString).deletingLastPathComponent
   }

   public var expandingTildeInPath: String {
      return (self as NSString).expandingTildeInPath
   }

   public func replacingCharacters(in nsRange: NSRange, with: String) -> String {
      return (self as NSString).replacingCharacters(in: nsRange, with: with)
   }

   public func nsRange(of searchString: String) -> NSRange {
      return (self as NSString).range(of: searchString)
   }
}

public extension String {

   public var componentsSeparatedByNewline: [String] {
      return components(separatedBy: .newlines)
   }

   public var uppercasedFirstCharacter: String {
      if characters.count > 0 {
         let splitIndex = index(after: startIndex)
         let firstCharacter = self[..<splitIndex].uppercased()
         let sentence = self[splitIndex...]
         return firstCharacter + sentence
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
}

// http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
public extension String {

   public func nsRange(from range: Range<String.Index>) -> NSRange? {
      guard let from = range.lowerBound.samePosition(in: utf16) else {
         return nil
      }
      guard let to = range.upperBound.samePosition(in: utf16) else {
         return nil
      }
      return NSRange(location: utf16.distance(from: utf16.startIndex, to: from), length: utf16.distance(from: from, to: to))
   }

   public func range(from nsRange: NSRange) -> Range<String.Index>? {
      guard
         let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
         let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
         let from = String.Index(from16, within: self),
         let to = String.Index(to16, within: self)
      else { return nil }
      return from ..< to
   }
}
