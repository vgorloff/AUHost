//
//  Property.swift
//  WLCore
//
//  Created by Vlad Gorlov on 03.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

/// Provides atomic access to Property.value from different threads.
public final class Property<T>: CustomReflectable {
	private var _value: T
	private let _lock: NonRecursiveLocking

	/// Locks getter/setter using NSLock while reading/writing operations.
	public var value: T {
		get {
			return _lock.synchronized {
				return _value
			}
		}
		set {
			_lock.synchronized {
				_value = newValue
			}
		}
	}

	public init(_ initialValue: T, lock: NonRecursiveLocking = SpinLock()) {
		_value = initialValue
		_lock = lock
	}

	public func customMirror() -> Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("value", _value), ("lock", _lock))
		return Mirror(self, children: children)
	}
}
