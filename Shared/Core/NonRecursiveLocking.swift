//
//  NonRecursiveLocking.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Darwin

public protocol NonRecursiveLocking {
	func synchronized<T>(@noescape closure: Void -> T) -> T
}

public final class SpinLock: NonRecursiveLocking {
	private var _lock: OSSpinLock = OS_SPINLOCK_INIT
	public init() {
	}
	public final func synchronized<T>(@noescape closure: Void -> T) -> T {
		OSSpinLockLock(&_lock)
		let result = closure()
		OSSpinLockUnlock(&_lock)
		return result
	}
}
