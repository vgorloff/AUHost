//
// NSLayoutConstraintUtility.swift
// WLUI
//
// Created by Vlad Gorlov on 02.02.16.
// Copyright © 2016 WaveLabs. All rights reserved.
//

#if os(iOS)
	import UIKit
#elseif os(OSX)
	import AppKit
#endif

public final class NSLayoutConstraintUtility: NSObject, CustomReflectable {
	@IBOutlet private weak var constraint: NSLayoutConstraint! {
		didSet {
			originalValue = constraint.constant
			if maxValue < originalValue {
				maxValue = originalValue
			}
		}
	}
	public var currentValue: CGFloat {
		return constraint.constant
	}
	public private(set) var originalValue: CGFloat = 0
	public var deltaValue: CGFloat {
		get {
			return originalValue - constraint.constant
		}
		set {
			checkAndAssingValueIfNeeded(originalValue + newValue)
		}
	}
	@IBInspectable public var minValue: CGFloat = 0 {
		didSet {
		}
	}
	@IBInspectable public var maxValue: CGFloat = 0 {
		didSet {
		}
	}

	public var relativeValue: CGFloat {
		return (constraint.constant - minValue) / (maxValue - minValue)
	}

	// MARK: -

	public func increment(delta: CGFloat) {
		checkAndAssingValueIfNeeded(constraint.constant + delta)
	}

	public func decrement(delta: CGFloat) {
		increment(-delta)
	}

	public func customMirror() -> Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("currentValue", currentValue),
			("originalValue", originalValue), ("minValue", minValue), ("maxValue", maxValue), ("deltaValue", deltaValue))
		return Mirror(self, children: children)
	}

	public func setToMin() {
		checkAndAssingValueIfNeeded(minValue)
	}

	public func setToMax() {
		checkAndAssingValueIfNeeded(maxValue)
	}

	// MARK: - Private
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
