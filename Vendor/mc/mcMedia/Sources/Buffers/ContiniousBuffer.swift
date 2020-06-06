//
//  ContiniousBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreGraphics
import Foundation

public protocol ContiniousBufferType {
   var millisecond: Int64 { get }
}

open class ContiniousBuffer<T: ContiniousBufferType> {

   var data: [T] = []

   public init(data: [T] = []) {
      self.data.reserveCapacity(10 * data.count) // FIXME: Calculate capacity more precisely.
      process(data: data)
   }

   public func process(data: [T]) {
      for sample in data {
         update(from: sample)
      }
   }
}

extension ContiniousBuffer {

   public var isEmpty: Bool {
      return data.isEmpty
   }

   public func filtered(bySampleRange range: Range<Int64>) -> [T] {
      let newData = data.filter { range.contains($0.millisecond) }
      return newData
   }
}

extension ContiniousBuffer {

   var timeRange: ClosedRange<Int64> {
      let from = data.first?.millisecond ?? 0
      let to = data.last?.millisecond ?? 0
      return from ... to
   }

   func sample(at timeStamp: Int64) -> T? {
      let sample = data.first(where: { $0.millisecond == timeStamp })
      return sample
   }
}

// MARK: - Private

extension ContiniousBuffer {

   private func update(from newSample: T) {
      if let existingIndex = data.firstIndex(where: { $0.millisecond == newSample.millisecond }) {
         data[existingIndex] = newSample
      } else {
         data.append(newSample)
      }
   }
}
