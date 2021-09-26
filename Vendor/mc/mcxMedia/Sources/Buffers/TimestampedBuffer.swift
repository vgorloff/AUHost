//
//  TimestampedBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class TimestampedBuffer<T> {

   var values: [Range<Int64>: T] = [:]

   public init() {}
}

extension TimestampedBuffer {

   public var isEmpty: Bool {
      return values.isEmpty
   }

   public func values(atRange range: Range<Int64>) -> [T] {
      let valuesInRange = values.filter { !$0.key.clamped(to: range).isEmpty }
      return valuesInRange.map { $0.value }
   }
}

extension TimestampedBuffer {

   func merge(with other: TimestampedBuffer<T>) {
      for (range, newValue) in other.values {
         setValue(newValue, inRange: range)
      }
   }

   public func setValue(_ value: T, inRange: Range<Int64>) {
      // TODO: Update later to eliminate ranges with similar values of `AverageOfMeasurement`.
      var newValues: [Range<Int64>: T] = [inRange: value]
      for (range, existingValue) in values {
         let clampedRange = range.clamped(to: inRange)
         if !clampedRange.isEmpty {
            let leftSide = range.lowerBound ..< clampedRange.lowerBound
            let rightSide = clampedRange.upperBound ..< range.upperBound
            if !leftSide.isEmpty {
               newValues[leftSide] = existingValue
            }
            if !rightSide.isEmpty {
               newValues[rightSide] = existingValue
            }
         } else {
            newValues[range] = existingValue
         }
      }
      values = newValues
   }

   public func value(atSampleTime: Int64) -> T? {
      let value = values.first(where: { $0.key.contains(atSampleTime) })?.value
      return value
   }
}
