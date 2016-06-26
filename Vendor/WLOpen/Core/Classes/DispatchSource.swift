//
//  DispatchSource.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 08.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

private protocol _DispatchSourceType: class {
	var dispatchSource: dispatch_source_t? { get set }
	// To prevent issue related to "BUG IN CLIENT OF LIBDISPATCH: Release of a suspended object"
	var dispatchSourceSuspendCount: Int { get set }
	var dispatchSourceCallback: (Void -> Void)? { get set }
	func _resume()
	func _suspend()
	func _cancel()
	func _deinit()
}

extension _DispatchSourceType {
	func _resume() {
		guard let tDispatchSource = dispatchSource else {
			return
		}
		if dispatchSourceSuspendCount > 0 {
			dispatch_resume(tDispatchSource)
			dispatchSourceSuspendCount -= 1
		}
	}

	func _suspend() {
		guard let tDispatchSource = dispatchSource else {
			return
		}
		dispatch_suspend(tDispatchSource)
		dispatchSourceSuspendCount += 1
	}

	func _cancel() {
		guard let tDispatchSource = dispatchSource else {
			return
		}
		if dispatch_source_testcancel(tDispatchSource) == 0 {
			dispatch_source_cancel(tDispatchSource)
		}
	}

	func _deinit() {
		dispatchSourceCallback = nil
		// To prevent issue related to "BUG IN CLIENT OF LIBDISPATCH: Release of a suspended object"
		while dispatchSourceSuspendCount > 0 {
			_resume()
		}
		_cancel()
		dispatchSource = nil
	}
}

public protocol DispatchSourceType: class {
	func resume()
	func suspend()
}

public final class DispatchSourceTimer: DispatchSourceType, _DispatchSourceType {

	private var dispatchSource: dispatch_source_t?
	private var dispatchSourceSuspendCount = 1
	public var dispatchSourceCallback: (Void -> Void)?

	public init(interval: NSTimeInterval, queue: dispatch_queue_t = dispatch_get_main_queue()) throws {
		dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
		guard let tDispatchSource = dispatchSource else {
			throw StateError.NotInitialized(String(dispatch_source_t))
		}
		let tInterval = abs(interval) * NSEC_PER_SEC.doubleValue
		let tLeeway = 0.1 * tInterval
		dispatch_source_set_timer(tDispatchSource, Dispatch.Time.now, tInterval.uint64Value, tLeeway.uint64Value)
		dispatch_source_set_event_handler(tDispatchSource) { [weak self] in
			self?.dispatchSourceCallback?()
		}
	}

	public func resume() {
		_resume()
	}

	public func suspend() {
		_suspend()
	}

	deinit {
		_deinit()
	}

	public func customMirror() -> Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("dispatchSourceSuspendCount", dispatchSourceSuspendCount))
		return Mirror(self, children: children)
	}
}


public final class DispatchSourceData: DispatchSourceType, _DispatchSourceType, CustomReflectable {
	public enum OperationType {
		case Add
		case Or // swiftlint:disable:this type_name
	}
	private var dispatchSource: dispatch_source_t?
	private var dispatchSourceSuspendCount = 1
	public var dispatchSourceCallback: (Void -> Void)?

	public init(type: OperationType, queue: dispatch_queue_t = dispatch_get_main_queue()) throws {
		switch type {
		case .Add: dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue)
		case .Or: dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_OR, 0, 0, queue)
		}
		guard let tDispatchSource = dispatchSource else {
			throw StateError.NotInitialized(String(dispatch_source_t))
		}
		dispatch_source_set_event_handler(tDispatchSource) { [weak self] in
			self?.dispatchSourceCallback?()
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

	public func suspend() {
		_suspend()
	}

	deinit {
		_deinit()
	}

	public func customMirror() -> Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral: ("dispatchSourceSuspendCount", dispatchSourceSuspendCount))
		return Mirror(self, children: children)
	}
}
