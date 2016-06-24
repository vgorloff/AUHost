//
//  Dispatch.swift
//  WLCore
//
//  Created by Vlad Gorlov on 14.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public struct Dispatch {
	public struct Async {
		public static func Main(block: dispatch_block_t) {
			dispatch_async(DispatchQueue.Main, block)
		}
		public static func UserInitiated(block: dispatch_block_t) {
			dispatch_async(DispatchQueue.UserInitiated, block)
		}
	}

	public struct Sync {
		/// If the current thread is main thread, then block will be executed without dispatching (to prevent deadlock).
		/// - parameter block: Block to dispatch.
		public static func Main(block: dispatch_block_t) {
			if NSThread.isMainThread() {
				block()
			} else {
				dispatch_sync(DispatchQueue.Main, block)
			}
		}
	}

	public struct Semaphore {
		private let sema: dispatch_semaphore_t
		public init(initialValue: Int = 0) {
			sema = dispatch_semaphore_create(initialValue)
		}
		public func signal() -> Int {
			return dispatch_semaphore_signal(sema)
		}
		public func wait(timeout: dispatch_time_t = DISPATCH_TIME_FOREVER, @noescape completion: Void -> Void) -> Int {
			let status = dispatch_semaphore_wait(sema, timeout)
			completion()
			return status
		}
	}

	public struct Time {
		public static func time(when: dispatch_time_t = DISPATCH_TIME_NOW, deltaNanoseconds: Int64) -> dispatch_time_t {
			return dispatch_time(when, deltaNanoseconds)
		}
		public static func time(when: dispatch_time_t = DISPATCH_TIME_NOW, deltaMicroseconds: Int64) -> dispatch_time_t {
			return dispatch_time(when, NSEC_PER_USEC.int64Value * deltaMicroseconds)
		}
		public static func time(when: dispatch_time_t = DISPATCH_TIME_NOW, deltaMilliseconds: Int64) -> dispatch_time_t {
			return dispatch_time(when, NSEC_PER_MSEC.int64Value * deltaMilliseconds)
		}
		public static func time(when: dispatch_time_t = DISPATCH_TIME_NOW, deltaSeconds: Int64) -> dispatch_time_t {
			return dispatch_time(when, NSEC_PER_SEC.int64Value * deltaSeconds)
		}
		public static func time(when: dispatch_time_t = DISPATCH_TIME_NOW, deltaSeconds: NSTimeInterval) -> dispatch_time_t {
			return dispatch_time(when, (NSEC_PER_SEC.doubleValue * deltaSeconds).int64Value)
		}
		public static var now: dispatch_time_t {
			return dispatch_time(DISPATCH_TIME_NOW, 0)
		}
	}
}
