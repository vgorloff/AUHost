//
//  ValueHistory.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.02.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

public protocol ValueHistoryType {
   static func - (lhs: Self, rhs: Self) -> Self
}

public struct ValueHistory<T: ValueHistoryType>: CustomReflectable {

   public private(set) var initial: T

   public var current: T {
      willSet {
         previous = current
      }
   }

   public private(set) var previous: T

   public init(_ value: T) {
      initial = value
      current = value
      previous = value
   }

   public var delta: T {
      return current - initial
   }

   public var increment: T {
      return current - previous
   }

   public mutating func reset(_ value: T? = nil) {
      if let newValue = value {
         initial = newValue
         current = newValue
         previous = newValue
      } else {
         current = initial
         previous = initial
      }
   }

   public var customMirror: Mirror {
      let children = KeyValuePairs<String, Any>(dictionaryLiteral: ("initial", initial), ("current", current),
                                                ("previous", previous), ("delta", delta), ("increment", increment))
      return Mirror(self, children: children)
   }
}

extension CGPoint: ValueHistoryType {

   public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
      return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
   }
}

extension CGSize: ValueHistoryType {

   public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
      return CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
   }
}
