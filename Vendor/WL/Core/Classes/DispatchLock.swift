//
//  DispatchLock.swift
//  WLCore
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

@available(*, message="Too slow. Use other lock")
public final class DispatchLock /*: NonRecursiveLocking */ {
	private let _lockQueue = dispatch_queue_create("ua.com.wavelabs.lockingQueue", DISPATCH_QUEUE_SERIAL)
	public init() {
	}
	public final func synchronized<T>(closure: Void -> T) -> T {
		var result: T!
		dispatch_sync(_lockQueue) {
			result = closure()
		}
		return result
	}
}
