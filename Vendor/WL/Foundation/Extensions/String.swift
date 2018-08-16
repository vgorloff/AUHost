//
//  String.swift
//  mcFoundation
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

// NSString bindings
public extension String {

   var url: URL? {
      return URL(string: self)
   }

   func appendingPathComponent(_ str: String) -> String {
      return (self as NSString).appendingPathComponent(str)
   }

   var pathExtension: String {
      return (self as NSString).pathExtension
   }

   var deletingPathExtension: String {
      return (self as NSString).deletingPathExtension
   }

   func appendingPathExtension(_ str: String) -> String? {
      return (self as NSString).appendingPathExtension(str)
   }

   var lastPathComponent: String {
      return (self as NSString).lastPathComponent
   }

   var deletingLastPathComponent: String {
      return (self as NSString).deletingLastPathComponent
   }

   func deletingLastPathComponents(_ numberOfComponents: Int) -> String {
      var result = self
      for _ in 0 ..< numberOfComponents {
         result = result.deletingLastPathComponent
      }
      return result
   }

   var expandingTildeInPath: String {
      return (self as NSString).expandingTildeInPath
   }

   func replacingCharacters(in nsRange: NSRange, with: String) -> String {
      return (self as NSString).replacingCharacters(in: nsRange, with: with)
   }

   func nsRange(of searchString: String) -> NSRange {
      return (self as NSString).range(of: searchString)
   }
}

public extension String {

   var componentsSeparatedByNewline: [String] {
      return components(separatedBy: .newlines)
   }

}

public extension String {

   func uppercasedFirstCharacter() -> String {
      return uppercasedFirstCharacters(1)
   }

   func lowercasedFirstCharacter() -> String {
      return lowercasedFirstCharacters(1)
   }

   func uppercasedFirstCharacters(_ numberOfCharacters: Int) -> String {
      return changeCaseOfFirstCharacters(numberOfCharacters, action: .upper)
   }

   func lowercasedFirstCharacters(_ numberOfCharacters: Int) -> String {
      return changeCaseOfFirstCharacters(numberOfCharacters, action: .lower)
   }

   private enum Action { case lower, upper }

   private func changeCaseOfFirstCharacters(_ numberOfCharacters: Int, action: Action) -> String {
      let offset = max(0, min(numberOfCharacters, count))
      if offset > 0 {
         if offset == count {
            switch action {
            case .lower:
               return self.lowercased()
            case .upper:
               return self.uppercased()
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

public extension String {

   func stringByReplacingFirstOccurrence(of target: String, with replaceString: String) -> String {
      if let targetRange = range(of: target) {
         return replacingCharacters(in: targetRange, with: replaceString)
      }
      return self
   }

   func stringByReplacingLastOccurrence(of target: String, with replaceString: String) -> String {
      if let targetRange = range(of: target, options: .backwards, range: nil, locale: nil) {
         return replacingCharacters(in: targetRange, with: replaceString)
      }
      return self
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
}

extension String {

   var mutableAttributedString: NSMutableAttributedString {
      return NSMutableAttributedString(string: self)
   }

   var attributedString: NSAttributedString {
      return NSAttributedString(string: self)
   }
}

// http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
extension String {

   public func range(from nsRange: NSRange) -> Range<String.Index>? {
      return Range(nsRange, in: self)
   }
}

extension String {

   struct ComponentsSplitByDelimiter {
      let start: String
      let middle: String
      let end: String
   }

   private func numberOf(_ character: Character) -> Int {
      var result = 0
      for value in self where character == value {
         result += 1
      }
      return result
   }

   public func applyAttributesBetweenDelimiter(_ character: Character, attributes: [NSAttributedStringKey: Any],
                                               commonAttributes: [NSAttributedStringKey: Any]? = nil) -> NSAttributedString {
      let numCharacters = numberOf(character)
      guard numCharacters > 0 && numCharacters % 2 == 0 else {
         return NSAttributedString(string: self, attributes: commonAttributes)
      }

      guard let components = componentsDelimedBy(character) else {
         return NSAttributedString(string: self, attributes: commonAttributes)
      }

      let mutableString = NSMutableAttributedString()
      mutableString.append(NSAttributedString(string: components.start, attributes: commonAttributes))
      mutableString.append(NSAttributedString(string: components.middle, attributes: attributes))
      if !components.end.isEmpty {
         let restOfTheString = components.end.applyAttributesBetweenDelimiter(character,
                                                                              attributes: attributes,
                                                                              commonAttributes: commonAttributes)
         mutableString.append(restOfTheString)
      }
      return mutableString
   }

   func componentsDelimedBy(_ character: Character) -> ComponentsSplitByDelimiter? {

      let delimiter = String(character)

      guard let rangeOfStart = range(of: delimiter), !rangeOfStart.isEmpty else {
         return nil
      }

      let restOfTheString = String(self[rangeOfStart.upperBound...])
      guard let rangeOfEnd = restOfTheString.range(of: delimiter), !rangeOfEnd.isEmpty else {
         return nil
      }

      let partStart = String(self[..<rangeOfStart.lowerBound])
      let partMiddle = String(restOfTheString[..<rangeOfEnd.lowerBound])
      let partEnd = String(restOfTheString[rangeOfEnd.upperBound...])
      return ComponentsSplitByDelimiter(start: partStart, middle: partMiddle, end: partEnd)
   }
}

extension String {

   public func leftPadding(toLength: Int, withPad character: Character) -> String {
      let stringLength = count
      if stringLength < toLength {
         return String(repeatElement(character, count: toLength - stringLength)) + self
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
                      "\'": "\\'",
                      ]

      return entities
         .reduce(self) { string, entity in
            string.replacingOccurrences(of: entity.value, with: entity.key)
         }
         .replacingOccurrences(of: "\\\\", with: "\\")
   }
}
