//
//  NonRecursiveLocking.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Darwin

public protocol NonRecursiveLocking {
	func synchronized<T>( closure: @noescape (Void) -> T) -> T
}

public final class SpinLock: NonRecursiveLocking {
	private var _lock: OSSpinLock = OS_SPINLOCK_INIT
	public init() {
	}
	public final func synchronized<T>( closure: @noescape(Void) -> T) -> T {
		OSSpinLockLock(&_lock)
		let result = closure()
		OSSpinLockUnlock(&_lock)
		return result
	}
}

@available(OSX 10.12, *)
public final class UnfairLock: NonRecursiveLocking {
	private var _lock = os_unfair_lock_s()
	public init() {
	}
	public final func synchronized<T>( closure: @noescape(Void) -> T) -> T {
		os_unfair_lock_lock(&_lock)
		let result = closure()
		os_unfair_lock_unlock(&_lock)
		return result
	}
}
