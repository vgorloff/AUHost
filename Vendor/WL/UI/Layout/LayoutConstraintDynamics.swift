//
// LayoutConstraintDynamics.swift
// WLUI
//
// Created by Vlad Gorlov on 02.02.16.
// Copyright © 2016 WaveLabs. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public final class LayoutConstraintDynamics {

   private var constraint: NSLayoutConstraint

   public private(set) var originalValue: CGFloat
   public var currentValue: CGFloat {
      return constraint.constant
   }

   public var deltaValue: CGFloat {
      get {
         return originalValue - constraint.constant
      } set {
         checkAndAssingValueIfNeeded(value: originalValue + newValue)
      }
   }

   public var distanceToMin: CGFloat {
      return currentValue - minValue
   }

   public var distanceToMax: CGFloat {
      return maxValue - currentValue
   }

   public var minValue: CGFloat = 0
   public var maxValue: CGFloat = 0

   public var relativeValue: CGFloat {
      return (constraint.constant - minValue) / (maxValue - minValue)
   }

   public var relativePercentageValue: CGFloat {
      return relativeValue * 100
   }

   public init(constraint: NSLayoutConstraint) {
      self.constraint = constraint
      originalValue = constraint.constant
      if maxValue < originalValue {
         maxValue = originalValue
      }
   }
}

// MARK: - Public

extension LayoutConstraintDynamics {

   public func increment(delta: CGFloat) {
      checkAndAssingValueIfNeeded(value: constraint.constant + delta)
   }

   public func decrement(delta: CGFloat) {
      increment(delta: -delta)
   }

   public func resetToMin() {
      checkAndAssingValueIfNeeded(value: minValue)
   }

   public func resetToMax() {
      checkAndAssingValueIfNeeded(value: maxValue)
   }

   public func setMaxToInfinity() {
      maxValue = CGFloat.greatestFiniteMagnitude
      checkAndAssingValueIfNeeded(value: currentValue)
   }

   public func setMinToInfinity() {
      minValue = -CGFloat.greatestFiniteMagnitude
      checkAndAssingValueIfNeeded(value: currentValue)
   }
}

// MARK: - Private

extension LayoutConstraintDynamics {

   private func checkAndAssingValueIfNeeded(value: CGFloat) {
      var newValue = value
      if newValue > maxValue {
         newValue = maxValue
      }
      if newValue < minValue {
         newValue = minValue
      }
      if constraint.constant != newValue {
         constraint.constant = newValue
      }
   }
}

// MARK: - CustomReflectable

extension LayoutConstraintDynamics: CustomReflectable {

   public var customMirror: Mirror {
      let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("currentValue", currentValue),
                                                    ("originalValue", originalValue),
                                                    ("minValue", minValue),
                                                    ("maxValue", maxValue),
                                                    ("deltaValue", deltaValue))
      return Mirror(self, children: children)
   }
}
