//
//  StridableBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public protocol StridableBufferType {
   init()
}

extension Float: StridableBufferType {}

extension Array: StridableBufferType where Element == Float {}

open class StridableBuffer<T: StridableBufferType> {

   public enum LookupMode: Int {
      case expandingToNearestIndex, expandingToNearestValue
   }

   public enum Error: Swift.Error {
      case unexpectedDataStructure(String)
   }

   public enum Approximation: Int {
      case none, nearest
   }

   public let id: String
   public let stride: Int

   var ranges: [Range<Int>] = []
   var timeRanges: [Range<Int64>] = []
   var data: [T] = []
   var timestamp: Int64 = 0
   private var isTimestampAssigned = false

   public init(id: String, stride: Int) {
      self.id = id
      self.stride = stride
      let capacity = 100 * (1000 / stride) // FIXME: Calculate more precisely.
      data.reserveCapacity(capacity)
   }
}

extension StridableBuffer {

   var indexRange: Range<Int> {
      let lowerBound = ranges.first?.lowerBound ?? 0
      let upperBound = ranges.last?.upperBound ?? 0
      return lowerBound ..< upperBound
   }

   var timeRange: Range<Int64> {
      let result = timeRange(fromIndexRange: indexRange)
      return result
   }

   var isEmpty: Bool {
      return indexRange.isEmpty
   }
}

extension StridableBuffer {

   public func missedSamples(atRange: Range<Int64>) -> [Range<Int64>] {
      if atRange.isEmpty {
         return []
      }
      let existingRanges = timeRanges.map { $0.clamped(to: atRange) }.filter { !$0.isEmpty }
      if existingRanges.isEmpty {
         return [atRange]
      }
      var result: [Range<Int64>] = []
      if let first = existingRanges.first, first.lowerBound > atRange.lowerBound {
         result.append(atRange.lowerBound ..< first.lowerBound)
      }
      if existingRanges.count > 1 {
         for (index, currentRange) in existingRanges.enumerated() {
            if let nextRange = existingRanges.element(at: index + 1) {
               result.append(currentRange.upperBound ..< nextRange.lowerBound)
            }
         }
      }
      if let last = existingRanges.last, last.upperBound < atRange.upperBound {
         result.append(last.upperBound ..< atRange.upperBound)
      }
      return result
   }

   public func lookup(by range: Range<Int64>, mode: LookupMode = .expandingToNearestIndex) -> Range<Int64> {
      switch mode {
      case .expandingToNearestIndex:
         return rangeToNearestIndex(range: range)
      case .expandingToNearestValue:
         fatalError("Not implemented")
      }
   }

   public func filtered(by range: Range<Int64>) -> ArraySlice<T> {
      if !isTimestampAssigned {
         return ArraySlice([])
      }
      var range = indexRange(fromTimeRange: range)
      range = range.clamped(to: indexRange)
      let result = data[range]
      return result
   }

   public func process(timestamp: Int64, data: [T]) throws {
      if data.isEmpty {
         return
      }
      if !isTimestampAssigned { // Initial write
         isTimestampAssigned = true
         self.timestamp = timestamp
         assert(self.data.isEmpty)
         self.data.insert(contentsOf: data, at: 0)
         ranges.append(0 ..< data.count)
      } else {
         let existingTimeRage = timeRange
         if existingTimeRage.lowerBound >= timestamp, existingTimeRage.upperBound <= timestamp + Int64(data.count * stride) {
            // Completely replacing whole data.
            self.data.removeAll(keepingCapacity: true)
            ranges.removeAll(keepingCapacity: true)
            self.data.insert(contentsOf: data, at: 0)
            ranges.append(0 ..< data.count)
         } else {
            let diff = timestamp >= self.timestamp ? Int(timestamp - self.timestamp) : -Int(self.timestamp - timestamp)
            let reminder = diff % stride
            if reminder != 0 {
               let msg = "Timestamp is misalligned for chart \"\(id)\". Current timestamp: \(self.timestamp). "
                  + "Timestamp from raw data: \(timestamp). Stride: \(stride)"
               throw Error.unexpectedDataStructure(msg)
            }
            var index = diff / stride
            if index < 0 {
               index = -index // For easier to understand calculations
               if data.count >= index { // We inserting at begining with possible overlap
                  do { // Replace (if needed)
                     let sourceRange = index ..< data.count
                     let destinationRange = 0 ..< data.count - index
                     self.data.replaceSubrange(destinationRange, with: data[sourceRange])
                  }
                  do { // Prepend
                     let sourceRange = 0 ..< index
                     self.data.insert(contentsOf: data[sourceRange], at: 0)
                     ranges = ranges.map { $0.lowerBound + sourceRange.count ..< $0.upperBound + sourceRange.count }
                     ranges[0] = 0 ..< ranges[0].upperBound
                  }
               } else {
                  let emptySpace = index - data.count
                  let emptyElements = repeatElement(T(), count: emptySpace)
                  self.data.insert(contentsOf: emptyElements, at: 0)
                  self.data.insert(contentsOf: data, at: 0)
                  ranges = ranges.map { $0.lowerBound + emptySpace + data.count ..< $0.upperBound + emptySpace + data.count }
                  ranges.insert(0 ..< data.count, at: 0)
               }
               self.timestamp = timestamp
            } else if (index + data.count) > self.data.count {
               if index <= self.data.count { // We appending at the end with possible overlap
                  do { // Replace (if needed)
                     let sourceRange = 0 ..< self.data.count - index
                     let destinationRange = index ..< self.data.count
                     self.data.replaceSubrange(destinationRange, with: data[sourceRange])
                  }
                  do { // Append
                     let sourceRange = self.data.count - index ..< data.count
                     self.data.append(contentsOf: data[sourceRange])
                     let lastRange = ranges[ranges.count - 1]
                     ranges[ranges.count - 1] = lastRange.lowerBound ..< lastRange.upperBound + sourceRange.count
                  }
               } else {
                  let emptySpace = index - self.data.count
                  let emptyElements = repeatElement(T(), count: emptySpace)
                  self.data.append(contentsOf: emptyElements)
                  self.data.append(contentsOf: data)
                  ranges.append(index ..< index + data.count)
               }
            } else {
               let range = index ..< index + data.count
               self.data.replaceSubrange(range, with: data)
               ranges.append(range)
               ranges = ranges.combined()
            }
         }
      }
      timeRanges = ranges.map { timeRange(fromIndexRange: $0) }
   }

   public func sample(at timeStamp: Int64, approximation: Approximation = .none) -> T? {
      if !isTimestampAssigned {
         return nil
      }
      if timeStamp >= timestamp {
         var diff = Int(timeStamp - timestamp)
         let remainder = diff % stride
         // FIXME: `timestamp` may point to empty space. Don't take next or previous value, as below. Approximate instead.
         diff -= remainder
         switch approximation {
         case .none:
            break
         case .nearest:
            if remainder > stride / 2 {
               diff += stride
            }
         }
         let index = diff / stride
         let rangeContainingValue = ranges.first(where: { $0.contains(index) })
         if rangeContainingValue == nil {
            return nil
         }
         return data.element(at: index)
      } else {
         return nil
      }
   }
}

extension StridableBuffer {

   private func timeRange(fromIndexRange range: Range<Int>) -> Range<Int64> {
      let lowerBound = Int64(range.lowerBound * stride) + timestamp
      let upperBound = Int64(range.upperBound * stride) + timestamp
      return lowerBound ..< upperBound
   }

   private func indexRange(fromTimeRange range: Range<Int64>) -> Range<Int> {
      let lowerBound = Int(range.lowerBound - timestamp) / stride
      let upperBound = Int(range.upperBound - timestamp) / stride
      return lowerBound ..< upperBound
   }

   private func rangeToNearestIndex(range: Range<Int64>) -> Range<Int64> {
      let stride = Int64(self.stride)
      var rangeStart = range.lowerBound
      var rangeEnd = range.upperBound

      // If reminders not equal to sero, then we expanding range to nearest strides.
      let reminderStart = (rangeStart - timestamp) % stride
      let reminderEnd = (rangeEnd - timestamp) % stride

      // Always moving backward
      if reminderStart > 0 {
         rangeStart -= reminderStart
      } else if reminderStart < 0 {
         rangeStart -= (stride + reminderStart)
      }

      // Always moving forward
      if reminderEnd > 0 {
         rangeEnd += (stride - reminderEnd)
      } else if reminderEnd < 0 {
         rangeEnd -= reminderEnd
      }

      var actualRange = rangeStart ..< rangeEnd
      actualRange = actualRange.clamped(to: timeRange)
      return actualRange
   }
}
