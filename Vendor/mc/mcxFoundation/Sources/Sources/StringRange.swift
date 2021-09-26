//
//  StringRange.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.06.19.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxFoundationExtensions
import mcxRuntime

extension NSRegularExpression {

   public func ranges(in range: StringRange, options: NSRegularExpression.MatchingOptions = []) -> [[StringRange]] {
      let m = asMatches.ranges(in: range.string, options: options, range: range.range)
      let result = m.map { $0.map { StringRange(string: range.string, range: $0) } }
      return result
   }
}

public struct StringRange {

   public private(set) var string: String
   public private(set) var startIndexOffset: String.IndexDistance
   public private(set) var endIndexOffset: String.IndexDistance
   public var shouldEraseIndexesOnExactReplace: Bool

   public init(string: String, shouldEraseIndexesOnExactReplace: Bool = true) {
      self.shouldEraseIndexesOnExactReplace = shouldEraseIndexesOnExactReplace
      self.string = string
      startIndexOffset = 0
      endIndexOffset = string.count
   }

   public init(string: String, range: Range<String.Index>, shouldEraseIndexesOnExactReplace: Bool = true) {
      self.shouldEraseIndexesOnExactReplace = shouldEraseIndexesOnExactReplace
      self.string = string
      startIndexOffset = string.distance(from: string.startIndex, to: range.lowerBound)
      endIndexOffset = string.distance(from: string.startIndex, to: range.upperBound)
   }
}

extension StringRange: Equatable {

   public static func == (lhs: StringRange, rhs: StringRange) -> Bool {
      return lhs.string == rhs.string
         && lhs.startIndexOffset == rhs.startIndexOffset
         && lhs.endIndexOffset == rhs.endIndexOffset
         && lhs.shouldEraseIndexesOnExactReplace == rhs.shouldEraseIndexesOnExactReplace
   }
}

extension StringRange {

   public var range: Range<String.Index> {
      return startIndex ..< endIndex
   }

   public var nsRange: NSRange {
      return NSRange(range, in: string)
   }

   public var length: Int {
      get {
         let result = endIndexOffset - startIndexOffset
         return result
      } set {
         let newValue = max(0, newValue)
         var newEndIndex = startIndexOffset + newValue
         newEndIndex = min(newEndIndex, string.count)
         endIndexOffset = newEndIndex
      }
   }

   public var substring: Substring {
      return string[range]
   }

   public var startIndex: String.Index {
      return string.index(string.startIndex, offsetBy: startIndexOffset)
   }

   public var endIndex: String.Index {
      return string.index(string.startIndex, offsetBy: endIndexOffset)
   }
}

extension StringRange {

   public mutating func prepend(_ value: String) {
      string = value + string
      startIndexOffset += value.count
      endIndexOffset += value.count
   }

   public mutating func append(_ value: String) {
      string += value
   }

   public func appending(_ value: String) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.append(value)
      return result
   }

   public func prepending(_ value: String) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.prepend(value)
      return result
   }

   public func replacingFirstOccurrence(of: String, with: String) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.replaceFirstOccurrence(of: of, with: with)
      return result
   }

   public mutating func shiftStartIndex(by distance: String.IndexDistance) {
      if distance == 0 {
         return // Nothing to do.
      }
      var newStartIndex = startIndexOffset + distance
      newStartIndex = max(0, newStartIndex)
      newStartIndex = min(newStartIndex, endIndexOffset)
      startIndexOffset = newStartIndex
   }

   public mutating func shiftEndIndex(by distance: String.IndexDistance) {
      if distance == 0 {
         return // Nothing to do.
      }
      var newEndIndex = endIndexOffset + distance
      newEndIndex = max(startIndexOffset, newEndIndex)
      newEndIndex = min(newEndIndex, string.count)
      endIndexOffset = newEndIndex
   }

   public mutating func shift(by distance: String.IndexDistance) {
      if distance == 0 {
         return // Nothing to do.
      }
      if distance < 0 {
         shiftStartIndex(by: distance)
         shiftEndIndex(by: distance)
      } else {
         shiftEndIndex(by: distance)
         shiftStartIndex(by: distance)
      }
   }

   public mutating func reset() {
      startIndexOffset = 0
      endIndexOffset = string.count
   }

   public func shifted(by: String.IndexDistance) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.shift(by: by)
      return result
   }

   public func shiftingStartIndex(by: String.IndexDistance) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.shiftStartIndex(by: by)
      return result
   }

   public func shiftingEndIndex(by: String.IndexDistance) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.shiftEndIndex(by: by)
      return result
   }

   public mutating func replaceFirstOccurrence(of: String, with: String) {
      if let existingRange = string.range(of: of) {
         replaceSubrange(existingRange, with: with)
      }
   }

   public func replacingSubrange(_ subrange: Range<String.Index>, with: String) -> StringRange {
      var result = StringRange(string: string, range: range, shouldEraseIndexesOnExactReplace: shouldEraseIndexesOnExactReplace)
      result.replaceSubrange(subrange, with: with)
      return result
   }

   mutating func replaceSubrange(_ subrange: Range<String.Index>, with: String) {
      let lowerBound = subrange.lowerBound.utf16Offset(in: string)
      let upperBound = subrange.upperBound.utf16Offset(in: string)
      replaceSubrange(lowerBound: lowerBound, upperBound: upperBound, with: with)
   }

   mutating func replaceSubrange(lowerBound: String.IndexDistance, upperBound: String.IndexDistance, with: String) {
      let range = string.index(string.startIndex, offsetBy: lowerBound) ..< string.index(string.startIndex, offsetBy: upperBound)
      let lengthDiff = with.count - (upperBound - lowerBound)

      if endIndexOffset <= lowerBound {
         // Replaced at end. Nothing to do with indexes.
      } else if upperBound <= startIndexOffset {
         // Replaced at the start.
         startIndexOffset += lengthDiff
         endIndexOffset += lengthDiff
      } else if lowerBound == startIndexOffset, endIndexOffset == upperBound {
         // Exact replace.
         if shouldEraseIndexesOnExactReplace {
            startIndexOffset = 0
            endIndexOffset = 0
         } else {
            endIndexOffset += lengthDiff
         }
      } else if lowerBound < startIndexOffset, endIndexOffset < upperBound {
         // Complete replace with overlap.
         startIndexOffset = 0
         endIndexOffset = 0
      } else if startIndexOffset < lowerBound, upperBound < endIndexOffset {
         // Replace withing range
         endIndexOffset += lengthDiff
      } else if lowerBound <= startIndexOffset, upperBound <= endIndexOffset {
         // Overlap left: |---L--S--U--E---|
         startIndexOffset = upperBound + lengthDiff
         endIndexOffset += lengthDiff
      } else if startIndexOffset <= lowerBound, endIndexOffset <= upperBound {
         // Overlap right: |---S--L--E--U---|
         endIndexOffset = lowerBound
      } else {
         assertionFailure("Should never happen")
      }
      string.replaceSubrange(range, with: with)
      noop()
   }
}

extension StringRange {

   private func dumpBounds() -> String {
      // See details about trick:
      // https://github.com/apple/swift/blob/15f2b00c9aa166dd4fe7810a8ff9e7243ec8aac5/stdlib/public/core/StringIndex.swift#L65
      // https://github.com/apple/swift/blob/15f2b00c9aa166dd4fe7810a8ff9e7243ec8aac5/stdlib/public/core/StringUTF16View.swift#L215
      let lower = startIndex.utf16Offset(in: string)
      let upper = endIndex.utf16Offset(in: string)
      return "[\(lower)..<\(upper)]"
   }

   func dump() -> String {
      let result = "\(dumpBounds()) (length:\(length)/string.count:\(string.count))"
      return result
   }
}

extension StringRange: CustomReflectable {

   public var customMirror: Mirror {
      let children: [Mirror.Child] = [("range", dump()), ("substring", substring), ("string", string)]
      return Mirror(self, children: children)
   }
}
