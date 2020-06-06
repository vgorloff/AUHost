//
//  String.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes

extension String {

   public var url: URL? {
      return URL(string: self)
   }
}

extension String {

   public var componentsSeparatedByNewline: [String] {
      return components(separatedBy: .newlines)
   }

   public var componentsSeparatedByWhitespace: [String] {
      return components(separatedBy: .whitespaces)
   }

   public var quoted: String {
      return surrounded(with: "")
   }

   public func surrounded(with string: String) -> String {
      return string + self + string
   }
}

extension String {

   public func uppercasedFirstCharacter() -> String {
      return uppercasedFirstCharacters(1)
   }

   public func lowercasedFirstCharacter() -> String {
      return lowercasedFirstCharacters(1)
   }

   public func uppercasedFirstCharacters(_ numberOfCharacters: Int) -> String {
      return changeCaseOfFirstCharacters(numberOfCharacters, action: .upper)
   }

   public func lowercasedFirstCharacters(_ numberOfCharacters: Int) -> String {
      return changeCaseOfFirstCharacters(numberOfCharacters, action: .lower)
   }

   private enum Action { case lower, upper }

   private func changeCaseOfFirstCharacters(_ numberOfCharacters: Int, action: Action) -> String {
      let offset = max(0, min(numberOfCharacters, count))
      if offset > 0 {
         if offset == count {
            switch action {
            case .lower:
               return lowercased()
            case .upper:
               return uppercased()
            }
         } else {
            let splitIndex = index(startIndex, offsetBy: offset)
            let firstCharacters: String
            switch action {
            case .lower:
               firstCharacters = self[..<splitIndex].lowercased()
            case .upper:
               firstCharacters = self[..<splitIndex].uppercased()
            }
            let sentence = self[splitIndex...]
            return firstCharacters + sentence
         }
      } else {
         return self
      }
   }
}

extension String {

   public func replacingFirstOccurrence(of target: String, with replaceString: String) -> String {
      if let targetRange = range(of: target) {
         return replacingCharacters(in: targetRange, with: replaceString)
      }
      return self
   }

   public func replacingLastOccurrence(of target: String, with replaceString: String) -> String {
      if let targetRange = range(of: target, options: .backwards, range: nil, locale: nil) {
         return replacingCharacters(in: targetRange, with: replaceString)
      }
      return self
   }

   /// - parameter length: Desired string length. Should be at least 4 characters.
   /// - returns: New string by replacing original string middle characters with ".."
   public func clip(toLength length: Int) -> String {
      if length < 4 || count < length {
         return self
      }

      let rangeEnd = length / 2 - 1 // "- 1" represents one dot "."
      let rangeStart = length - 2 - rangeEnd // "- 2" represents two dots ".."
      let indexStart = index(startIndex, offsetBy: rangeStart)
      let indexEnd = index(endIndex, offsetBy: -rangeEnd)
      let range = indexStart ..< indexEnd
      var string = self
      string.replaceSubrange(range, with: "..")
      return string
   }

   public var OSTypeValue: OSType {
      let chars = utf8
      var result: UInt32 = 0
      for aChar in chars {
         result = result << 8 + UInt32(aChar)
      }
      return result
   }
}

extension String {

   public var mutableAttributedString: NSMutableAttributedString {
      return NSMutableAttributedString(string: self)
   }

   public var attributedString: NSAttributedString {
      return NSAttributedString(string: self)
   }
}

extension String {

   public var range: __StringAsRange {
      return __StringAsRange(instance: self)
   }
}

public class __StringAsRange: InstanceHolder<String> {

   public enum SearchDirection: Int {
      case forward, backward
   }

   public func rangesDelimitedBy(character: Character,
                                 searchDirection: SearchDirection = .forward,
                                 inRange range: Range<String.Index>? = nil) -> [Range<String.Index>] {
      let defaultSearchRange = range ?? instance.startIndex ..< instance.endIndex
      guard let matchingRange = firstRangeDelimitedBy(character: character, searchDirection: searchDirection, range: defaultSearchRange) else {
         return []
      }
      let remainingPart: Range<String.Index>
      switch searchDirection {
      case .forward:
         remainingPart = instance.index(after: matchingRange.upperBound) ..< defaultSearchRange.upperBound
      case .backward:
         remainingPart = defaultSearchRange.lowerBound ..< instance.index(before: matchingRange.lowerBound)
      }
      let childRanges = rangesDelimitedBy(character: character, searchDirection: searchDirection, inRange: remainingPart)
      let result = [matchingRange] + childRanges
      return result
   }

   public func firstRangeDelimitedBy(character: Character,
                                     searchDirection: SearchDirection = .forward,
                                     range: Range<String.Index>? = nil) -> Range<String.Index>? {
      firstRangeDelimitedBy(lowerCharacter: character, upperCharacter: character, searchDirection: searchDirection, range: range)
   }

   public func firstRangeDelimitedBy(lowerCharacter: Character, upperCharacter: Character,
                                     searchDirection: SearchDirection = .forward,
                                     range: Range<String.Index>? = nil) -> Range<String.Index>? {
      let defaultSearchRange = range ?? instance.startIndex ..< instance.endIndex
      let lowerCharSet = CharacterSet(charactersIn: String(lowerCharacter))
      let upperCharSet = CharacterSet(charactersIn: String(upperCharacter))
      switch searchDirection {
      case .forward:
         guard let rangeLower = instance.rangeOfCharacter(from: lowerCharSet, options: [], range: defaultSearchRange) else {
            return nil
         }
         let searchRange = rangeLower.upperBound ..< defaultSearchRange.upperBound
         guard let rangeUpper = instance.rangeOfCharacter(from: upperCharSet, range: searchRange) else {
            return nil
         }
         return rangeLower.upperBound ..< rangeUpper.lowerBound
      case .backward:
         guard let rangeUpper = instance.rangeOfCharacter(from: upperCharSet, options: [.backwards], range: defaultSearchRange) else {
            return nil
         }
         let searchRange = defaultSearchRange.lowerBound ..< rangeUpper.lowerBound
         guard let rangeLower = instance.rangeOfCharacter(from: lowerCharSet, options: [.backwards], range: searchRange) else {
            return nil
         }
         return rangeLower.upperBound ..< rangeUpper.lowerBound
      }
   }
}

extension String {

   // See also: https://stackoverflow.com/a/42567641/1418981
   public func leftPadding(toLength: Int, withPad character: Character) -> String {
      let stringLength = count
      if stringLength < toLength {
         return String(repeatElement(character, count: toLength - stringLength)) + self
      } else {
         return self
      }
   }

   public func removingPrefix(_ prefix: String) -> String {
      if hasPrefix(prefix), !prefix.isEmpty {
         return String(dropFirst(prefix.count))
      } else {
         return self
      }
   }

   public func removingSuffix(_ suffix: String) -> String {
      if hasSuffix(suffix), !suffix.isEmpty {
         return String(dropLast(suffix.count))
      } else {
         return self
      }
   }
}

extension String {

   // See: https://stackoverflow.com/questions/39488488/unescaping-backslash-in-swift
   public var unescaped: String {
      let entities = ["\0": "\\0",
                      "\t": "\\t",
                      "\n": "\\n",
                      "\r": "\\r",
                      "\"": "\\\"",
                      "\'": "\\'"]

      return entities
         .reduce(self) { string, entity in
            string.replacingOccurrences(of: entity.value, with: entity.key)
         }
         .replacingOccurrences(of: "\\\\", with: "\\")
   }
}
