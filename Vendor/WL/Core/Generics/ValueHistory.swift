//
//  ValueHistory.swift
//  WLCore
//
//  Created by Vlad Gorlov on 02.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public protocol ValueHistoryType {
	func - (lhs: Self, rhs: Self) -> Self
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
	public mutating func reset(value: T? = nil) {
		if let v = value {
			initial = v
			current = v
			previous = v
		} else {
			current = initial
			previous = initial
		}
	}
	public func customMirror() -> Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("initial", initial),
         ("current", current), ("previous", previous), ("delta", delta), ("increment", increment))
		return Mirror(self, children: children)
	}
}
