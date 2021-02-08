//
//  String+Ranges.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension String {

   public subscript(index: NSRange) -> Substring {
      let range = asRanges.range(from: index)
      return self[range]
   }

   public var asIndexes: _StringIndexes {
      return _StringIndexes(instance: self)
   }

   public var asRanges: _StringRanges {
      return _StringRanges(instance: self)
   }
}

// See also:
// - http://stackoverflow.com/questions/25138339/nsrange-to-rangestring-index
public class _StringRanges {

   private let instance: String

   fileprivate init(instance: String) {
      self.instance = instance
   }

   public var wholeStringNSRange: NSRange {
      return NSRange(wholeStringRange, in: instance)
   }

   public var wholeStringRange: Range<String.Index> {
      return instance.startIndex ..< instance.endIndex
   }

   public func range(from nsRange: UTF16Range) -> Range<String.Index> {
      let lowerBound = String.Index(utf16Offset: nsRange.lowerBound, in: instance)
      let upperBound = String.Index(utf16Offset: nsRange.upperBound, in: instance)
      let range = lowerBound ..< upperBound
      return range
   }

   public func checkedRange(from nsRange: NSRange) -> Range<String.Index>? {
      return Range(nsRange, in: instance)
   }

   public func nsRange(from: Range<String.Index>) -> NSRange {
      return NSRange(from, in: instance)
   }

   public func convert(nsRanges: [UTF16Range]) -> [Range<String.Index>] {
      let result = nsRanges.map { range(from: $0) }
      return result
   }
}

public class _StringIndexes {

   private let instance: String

   fileprivate init(instance: String) {
      self.instance = instance
   }

   public func startIndex(offsetBy: String.IndexDistance) -> String.Index {
      return instance.index(instance.startIndex, offsetBy: offsetBy)
   }

   public func endIndex(offsetBy: String.IndexDistance) -> String.Index {
      return instance.index(instance.endIndex, offsetBy: offsetBy)
   }

   public func distance(in range: Range<String.Index>) -> String.IndexDistance {
      return instance.distance(from: range.lowerBound, to: range.upperBound)
   }
}
