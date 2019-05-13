//
//  String.swift
//  mcFoundation
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

// NSString bindings
extension String {

   public var url: URL? {
      return URL(string: self)
   }

   public func appendingPathComponent(_ str: String) -> String {
      return (self as NSString).appendingPathComponent(str)
   }

   public func appendingPathComponents(_ values: [String]) -> String {
      return values.reduce(self) { $0.appendingPathComponent($1) }
   }

   public func appendingPathComponents(_ values: String...) -> String {
      return appendingPathComponents(values)
   }

   public var pathExtension: String {
      return (self as NSString).pathExtension
   }

   public var pathComponents: [String] {
      return (self as NSString).pathComponents
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

   public func deletingLastPathComponents(_ numberOfComponents: Int) -> String {
      var result = self
      for _ in 0 ..< numberOfComponents {
         result = result.deletingLastPathComponent
      }
      return result
   }

   public var expandingTildeInPath: String {
      return (self as NSString).expandingTildeInPath
   }

   public var abbreviatingWithTildeInPath: String {
      return (self as NSString).abbreviatingWithTildeInPath
   }

   public func replacingCharacters(in nsRange: NSRange, with: String) -> String {
      return (self as NSString).replacingCharacters(in: nsRange, with: with)
   }

   public func nsRange(of searchString: String) -> NSRange {
      return (self as NSString).range(of: searchString)
   }
}

extension String {

   public var componentsSeparatedByNewline: [String] {
      return components(separatedBy: .newlines)
   }

   public var quoted: String {
      return self.surrounded(with: "")
   }

   public func surrounded(with string: String) -> String {
      return string + self + string
   }
}

extension String {

   public var base64Encoded: String? {
      return data(using: .utf8)?.base64EncodedString()
   }

   public var base64Decoded: String? {
      guard let data = Data(base64Encoded: self) else {
         return nil
      }
      return String(data: data, encoding: .utf8)
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

   public func applyAttributesBetweenDelimiter(_ character: Character, attributes: [NSAttributedString.Key: Any],
                                               commonAttributes: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString {
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

   public func rangeBetweenCharacters(lower: Character, upper: Character, isBackwardSearch: Bool = true) -> Range<String.Index>? {
      guard let rangeLower = rangeOfCharacter(from: CharacterSet(charactersIn: String(lower)), options: []) else {
         return nil
      }
      if isBackwardSearch {
         guard let rangeUpper = rangeOfCharacter(from: CharacterSet(charactersIn: String(upper)), options: [.backwards]) else {
            return nil
         }
         return rangeLower.upperBound ..< rangeUpper.lowerBound
      } else {
         let searchRange = rangeLower.upperBound ..< endIndex
         guard let rangeUpper = rangeOfCharacter(from: CharacterSet(charactersIn: String(upper)), range: searchRange) else {
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
         let range = startIndex.shifting(by: prefix.count, in: self)
         return String(self[range...])
      } else {
         return self
      }
   }

   public func removingSuffix(_ suffix: String) -> String {
      if hasSuffix(suffix), !suffix.isEmpty {
         let range = endIndex.shifting(by: -suffix.count, in: self)
         return String(self[..<range])
      } else {
         return self
      }
   }

   public func range(start: Int, end: Int) -> Range<String.Index> {
      let range = String.Index(utf16Offset: start, in: self) ..< String.Index(utf16Offset: end, in: self)
      return range
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
