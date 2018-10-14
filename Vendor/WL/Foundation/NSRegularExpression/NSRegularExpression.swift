//
//  NSRegularExpression.swift
//  mcApp
//
//  Created by Vlad Gorlov on 09.06.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
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

   public func matches(in string: String, options: NSRegularExpression.MatchingOptions = [],
                       range: Range<String.Index>? = nil) -> [[Range<String.Index>]] {
      let range = range ?? string.startIndex ..< string.endIndex
      let nsRange = NSRange(range, in: string)
      let matches = self.matches(in: string, options: options, range: nsRange)
      let result = matches.map { ranges(string: string, match: $0) }
      return result
   }
}

extension NSRegularExpression {

   private func ranges(string: String, match: NSTextCheckingResult) -> [Range<String.Index>] {
      var result: [Range<String.Index>] = []
      for index in 0 ..< match.numberOfRanges {
         let nsRange = match.range(at: index)
         if let range = Range(nsRange, in: string) {
            result.append(range)
         }
      }
      return result
   }
}
