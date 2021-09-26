//
//  Array.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Array where Element == String {

   public init(cArray: UnsafePointer<UnsafePointer<CChar>>, length: Int) {
      var result: [String] = []
      for index in 0 ..< length {
         let value = String(cString: cArray[index])
         result.append(value)
      }
      self.init(result)
   }

   public func select(_ regexes: [NSRegularExpression], options: NSRegularExpression.MatchingOptions = []) -> [Element] {
      return filter { value in
         let passes = regexes.map { regex in regex.test(input: value, options: options) }
         return !passes.contains(false)
      }
   }

   public func reject(_ regexes: [NSRegularExpression], options: NSRegularExpression.MatchingOptions = []) -> [Element] {
      return filter { value in
         let passes = regexes.map { regex in !regex.test(input: value, options: options) }
         return !passes.contains(false)
      }
   }
}

extension Array {

   public func element(at index: Int) -> Element? {
      if index < 0 || index >= count {
         return nil
      }
      return self[index]
   }

   public func chunked(into size: Int) -> [[Element]] {
      return stride(from: 0, to: count, by: size).map {
         Array(self[$0 ..< Swift.min($0 + size, count)])
      }
   }

   public func toDictionary<T>(_ transform: (Element) -> T) -> [T: Element] where T: Hashable {
      return reduce([:]) {
         var dic = $0
         dic[transform($1)] = $1
         return dic
      }
   }
}

extension Array where Element: Equatable {

   public var distinct: [Element] {
      var uniqueValues: [Element] = []
      forEach { item in
         if !uniqueValues.contains(item) {
            uniqueValues.append(item)
         }
      }
      return uniqueValues
   }

   public func ordered(by preferredOrder: [Element]) -> [Element] {
      // See also: https://stackoverflow.com/a/51683055/1418981
      return sorted { left, right in
         guard let first = preferredOrder.firstIndex(of: left) else {
            return false
         }
         guard let second = preferredOrder.firstIndex(of: right) else {
            return true
         }
         return first < second
      }
   }
}

extension Array where Element: Hashable {

   public func subtracting(_ other: [Element]) -> [Element] {
      return Array(Set(self).subtracting(Set(other)))
   }
}

extension Array where Element: Comparable & Hashable {

   public var duplicates: [Element] {

      let sortedElements = sorted { $0 < $1 }
      var duplicatedElements = Set<Element>()

      var previousElement: Element?
      for element in sortedElements {
         if previousElement == element {
            duplicatedElements.insert(element)
         }
         previousElement = element
      }

      return Array(duplicatedElements)
   }

   public var hasDuplicates: Bool {
      return !duplicates.isEmpty
   }
}

extension Array {

   public mutating func removeAll(_ matching: (Element) throws -> Bool) rethrows {
      self = try filter { try !matching($0) }
   }
}

extension Array where Element == Range<Int> {

   public func combined() -> [Range<Int>] {
      var combined = [Range<Int>]()
      var accumulator = 0 ..< 0 // empty range
      for interval in sorted(by: { $0.lowerBound < $1.lowerBound }) {
         if accumulator == 0 ..< 0 {
            accumulator = interval
         }
         if accumulator.upperBound >= interval.upperBound {
            // interval is already inside accumulator
         } else if accumulator.upperBound >= interval.lowerBound {
            // interval hangs off the back end of accumulator
            accumulator = accumulator.lowerBound ..< interval.upperBound
         } else if accumulator.upperBound <= interval.lowerBound {
            // interval does not overlap
            combined.append(accumulator)
            accumulator = interval
         }
      }
      if accumulator != 0 ..< 0 {
         combined.append(accumulator)
      }
      return combined
   }
}
