//
//  NonRecursiveMutex.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 25.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

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
		_mutex = UnsafeMutablePointer.alloc(sizeof(pthread_mutex_t))
		pthread_mutex_init(_mutex, nil)
	}
	public final func synchronized<T>(@noescape closure: Void -> T) -> T {
		pthread_mutex_lock(_mutex)
		let result = closure()
		pthread_mutex_unlock(_mutex)
		return result
	}
	deinit {
		pthread_mutex_destroy(_mutex)
	}
}
