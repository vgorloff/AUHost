//
//  ValueChange.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 12/05/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

public struct ValueChange<T: Equatable>: CustomReflectable {

   private var mCurrent: T

   public var current: T {
      set {
         previous = mCurrent
         mCurrent = newValue
         if previous != mCurrent {
            valueChanged?(newValue)
         }
      }
      get {
         return mCurrent
      }
   }

   public private(set) var previous: T
   public var valueChanged: ((T) -> Void)?

   // MARK: - Init / Deinit

   public init(_ value: T) {
      mCurrent = value
      previous = value
   }

   // MARK: - Public

   public mutating func reset(_ value: T) {
      mCurrent = value
      previous = value
   }

   public func forceChange() {
      valueChanged?(mCurrent)
   }

   public var customMirror: Mirror {
      let children = KeyValuePairs<String, Any>(dictionaryLiteral: ("current", current), ("previous", previous))
      return Mirror(self, children: children)
   }
}
