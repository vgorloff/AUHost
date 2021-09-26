//
//  NSRegularExpression.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension NSRegularExpression {

   public func replace(string: String, withTemplate: String, options: NSRegularExpression.MatchingOptions = [],
                       range: Range<String.Index>? = nil) -> String {
      let range = range ?? string.startIndex ..< string.endIndex
      let nsRange = NSRange(range, in: string)
      let result = stringByReplacingMatches(in: string, options: options, range: nsRange, withTemplate: withTemplate)
      return result
   }

   public func test(input: String, options: NSRegularExpression.MatchingOptions = [], range: Range<String.Index>? = nil) -> Bool {
      let range = range ?? input.startIndex ..< input.endIndex
      let nsRange = NSRange(range, in: input)
      let numMatches = numberOfMatches(in: input, options: options, range: nsRange)
      return numMatches > 0
   }

   public var asMatches: RegularExpressionMatches {
      return RegularExpressionMatches(instance: self)
   }
}

public class RegularExpressionMatches {

   public typealias Options = NSRegularExpression.MatchingOptions

   private let instance: NSRegularExpression

   fileprivate init(instance: NSRegularExpression) {
      self.instance = instance
   }

   public func ranges(in string: String, options: Options = [], range: Range<String.Index>? = nil) -> [[Range<String.Index>]] {
      let ranges = nsRanges(in: string, options: options, range: range)
      var result: [[Range<String.Index>]] = []
      for item in ranges {
         result.append(string.asRanges.convert(nsRanges: item))
      }
      return result
   }

   public func nsRanges(in string: String, options: Options = [], range: Range<String.Index>? = nil) -> [[NSRange]] {
      let range = range.map { string.asRanges.nsRange(from: $0) } ?? string.asRanges.wholeStringNSRange
      return nsRanges(in: string, options: options, nsRange: range)
   }

   public func nsRanges(in string: String, options: Options = [], nsRange: NSRange? = nil) -> [[NSRange]] {
      let range = nsRange ?? string.asRanges.wholeStringNSRange
      let matches = instance.matches(in: string, options: options, range: range)
      let result = matches.map { $0.allRanges }
      return result
   }
}
