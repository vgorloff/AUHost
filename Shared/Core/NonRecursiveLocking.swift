//
//  NonRecursiveLocking.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Darwin
import Foundation

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

public final class NSLocker: NonRecursiveLocking {
   private let lock = NSLock()
   public init () {
   }
   public final func synchronized<T>(closure: (Void) -> T) -> T {
      lock.lock()
      let result = closure()
      lock.unlock()
      return result
   }
}

/// Wrapper class for locking block of code. Uses non-recursive pthread_mutex_t for locking.
/// ~~~
/// let s = NonRecursiveMutex()
/// let value = s.synchronized {
///     return "XYZ"
/// }
/// ~~~
public final class NonRecursiveMutex: NonRecursiveLocking {
   private let _mutex: UnsafeMutablePointer<pthread_mutex_t>
   public init() {
      _mutex = UnsafeMutablePointer.allocate(capacity: 1)
      pthread_mutex_init(_mutex, nil)
   }
   public final func synchronized<T>(closure: (Void) -> T) -> T {
      pthread_mutex_lock(_mutex)
      let result = closure()
      pthread_mutex_unlock(_mutex)
      return result
   }
   deinit {
      pthread_mutex_destroy(_mutex)
      _mutex.deallocate(capacity: 1)
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
