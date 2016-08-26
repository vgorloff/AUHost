//
//  NonRecursiveLocking.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Darwin

public protocol NonRecursiveLocking {
	func synchronized<T>( closure: (Void) -> T) -> T
}

public struct NonRecursiveLock {
	public static func makeDefaultLock() -> NonRecursiveLocking {
		if #available(OSX 10.12, iOS 10, *) {
			return UnfairLock()
		} else {
			return SpinLock()
		}
	}
}

@available(OSX 10.12, iOS 10, *)
public final class UnfairLock: NonRecursiveLocking {
	private var _lock = os_unfair_lock_s()
	public init() {
	}
	public final func synchronized<T>( closure: (Void) -> T) -> T {
		os_unfair_lock_lock(&_lock)
		let result = closure()
		os_unfair_lock_unlock(&_lock)
		return result
	}
}

@available(iOS, deprecated: 10.0)
public final class SpinLock: NonRecursiveLocking {
	private var lock: OSSpinLock = OS_SPINLOCK_INIT
	public init() {
	}
	public final func synchronized<T>( closure: (Void) -> T) -> T {
		OSSpinLockLock(&lock)
		let result = closure()
		OSSpinLockUnlock(&lock)
		return result
	}
}

/// Provides atomic access to Property.value from different threads.
public final class Property<T>: CustomReflectable {
	private var valueStorage: T
	private let lock: NonRecursiveLocking

	/// Locks getter/setter using NSLock while reading/writing operations.
	public var value: T {
		get {
			return lock.synchronized {
				return valueStorage
			}
		}
		set {
			lock.synchronized {
				valueStorage = newValue
			}
		}
	}

	public init(_ initialValue: T, lock: NonRecursiveLocking = NonRecursiveLock.makeDefaultLock()) {
		valueStorage = initialValue
		self.lock = lock
	}

	public var customMirror: Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("value", valueStorage), ("lock", lock))
		return Mirror(self, children: children)
	}
}

public final class WriteSynchronizedProperty<T>: CustomReflectable {
	private var valueStorage: T
	private let lock: NonRecursiveLocking

	/// Locks getter/setter using NSLock while reading/writing operations.
	public var value: T {
		get {
			return valueStorage
		}
		set {
			lock.synchronized {
				valueStorage = newValue
			}
		}
	}

	public init(_ initialValue: T, lock: NonRecursiveLocking = NonRecursiveLock.makeDefaultLock()) {
		valueStorage = initialValue
		self.lock = lock
	}

	public var customMirror: Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("value", valueStorage), ("lock", lock))
		return Mirror(self, children: children)
	}
}
