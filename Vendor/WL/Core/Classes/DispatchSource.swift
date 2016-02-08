//
//  DispatchSource.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

private protocol _DispatchSourceType: class {
	var dispatchSource: dispatch_source_t? { get set }
	var timerIsRunning: Bool { get set }
	func _resume()
	func _cancel()
}

extension _DispatchSourceType {
	func _resume() {
		guard let tTimerSource = dispatchSource where !timerIsRunning else {
			return
		}
		dispatch_resume(tTimerSource)
		timerIsRunning = true
	}

	func _cancel() {
		guard let tTimerSource = dispatchSource where timerIsRunning else {
			return
		}
		if dispatch_source_testcancel(tTimerSource) == 0 {
			dispatch_source_cancel(tTimerSource)
			timerIsRunning = false
			dispatchSource = nil
		}
	}
}

private protocol DispatchSourceType: class {
	func resume()
	func cancel()
}

public final class DispatchSourceTimer: DispatchSourceType, _DispatchSourceType {

	private var dispatchSource: dispatch_source_t?
	private var timerIsRunning = false
	public var timerCallback: (Void -> Void)?

	public init(interval: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue()) throws {
		dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
		guard let tTimerSource = dispatchSource else {
			throw StateError.NotInitialized(String(dispatch_source_t))
		}
		let tInterval = UInt64(Double.abs(interval)) * NSEC_PER_SEC
		let tLeeway = UInt64(0.1 * Double(tInterval))
		dispatch_source_set_timer(tTimerSource, Dispatch.Time.now, tInterval, tLeeway)
		dispatch_source_set_event_handler(tTimerSource) { [weak self] in
			self?.timerCallback?()
		}
	}

	public func resume() {
		_resume()
	}

	public func cancel() {
		_cancel()
	}

	deinit {
		cancel()
	}
}


public final class DispatchSourceData: DispatchSourceType, _DispatchSourceType {
	public enum OperationType {
		case Add
		case Or // swiftlint:disable:this type_name
	}
	private var dispatchSource: dispatch_source_t?
	private var timerIsRunning = false
	public var mergeDataCallback: (Void -> Void)?

	public init(type: OperationType, queue: dispatch_queue_t = dispatch_get_main_queue()) throws {
		switch type {
		case .Add: dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue)
		case .Or: dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_OR, 0, 0, queue)
		}
		guard let tDispatchSource = dispatchSource else {
			throw StateError.NotInitialized(String(dispatch_source_t))
		}
		dispatch_source_set_event_handler(tDispatchSource) { [weak self] in
			self?.mergeDataCallback?()
		}
	}

	public func mergeData(value: UInt) {
		guard let tDispatchSource = dispatchSource else {
			return
		}
		dispatch_source_merge_data(tDispatchSource, value)
	}

	public func resume() {
		_resume()
	}

	public func cancel() {
		_cancel()
	}

	deinit {
		cancel()
	}
}
