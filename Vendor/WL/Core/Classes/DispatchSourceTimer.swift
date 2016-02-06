//
//  DispatchSourceTimer.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

public final class DispatchSourceTimer {

	private var timerSource: dispatch_source_t?
	public var timerCallback: (Void -> Void)?
	private var timerIsRunning = false

	public init(interval: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue()) throws {
		timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
		guard let tTimerSource = timerSource else {
			throw StateError.NotInitialized(String(dispatch_source_t))
		}
		let tInterval = UInt64(Double.abs(interval)) * NSEC_PER_SEC
		let tLeeway = UInt64(0.1 * Double(tInterval))
		dispatch_source_set_timer(tTimerSource, dispatch_time(DISPATCH_TIME_NOW, 0), tInterval, tLeeway)
		dispatch_source_set_event_handler(tTimerSource) { [weak self] in
			if let cb = self?.timerCallback {
				cb()
			}
		}
	}

	public func resume() {
		guard let tTimerSource = timerSource where !timerIsRunning else {
			return
		}

		dispatch_resume(tTimerSource)
		timerIsRunning = true
	}

	public func cancel() {
		guard let tTimerSource = timerSource where timerIsRunning else {
			return
		}
		if dispatch_source_testcancel(tTimerSource) == 0 {
			dispatch_source_cancel(tTimerSource)
			timerIsRunning = false
			timerSource = nil
		}
	}

	deinit {
		cancel()
	}
}
