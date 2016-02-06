//
//  NSLocker.swift
//  WLCore
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public final class NSLocker: NonRecursiveLocking {
	private let _lock = NSLock()
	public init () {
	}
	public final func synchronized<T>(@noescape closure: Void -> T) -> T {
		_lock.lock()
		let result = closure()
		_lock.unlock()
		return result
	}
}
