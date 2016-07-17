//
//  Property.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

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

	public init(_ initialValue: T, lock: NonRecursiveLocking = SpinLock()) {
		valueStorage = initialValue
      if #available(OSX 10.12, *) {
         self.lock = UnfairLock()
      } else {
         self.lock = lock
      }
	}

	public var customMirror: Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("value", valueStorage), ("lock", lock))
		return Mirror(self, children: children)
	}
}
