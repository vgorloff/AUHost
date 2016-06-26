//
//  AsynchronousOperation.swift
//  WLCore
//
//  Created by Vlad Gorlov on 26.07.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public class AsynchronousOperation: NSOperation {

	private var lockOfProperties: NonRecursiveLocking = SpinLock()
	private var lockOfHandlers: NonRecursiveLocking = SpinLock()

	private var _finished = false
	private var _executing = false

	private var _onStartHandler: (Void -> Void)? = nil
	private var _onCancelHandler: (Void -> Void)? = nil
	private var _onFinishHandler: (Void -> Void)? = nil

	// MARK: -

	public final override var asynchronous: Bool {
		return true
	}

	public final override var executing: Bool {
		return lockOfProperties.synchronized { _executing }
	}

	public final override var finished: Bool {
		return lockOfProperties.synchronized { _finished }
	}

	/// Called immediately after calling onStart() method.
	public final var onStartHandler: (Void -> Void)? {
		get {
			return lockOfHandlers.synchronized { _onStartHandler }
		}
		set {
			lockOfHandlers.synchronized { _onStartHandler = newValue }
		}
	}

	/// Called immediately after calling onCancel() method.
	public final var onCancelHandler: (Void -> Void)? {
		get {
			return lockOfHandlers.synchronized { _onCancelHandler }
		}
		set {
			lockOfHandlers.synchronized { _onCancelHandler = newValue }
		}
	}

	/// Called immediately after calling onFinish() method.
	public final var onFinishHandler: (Void -> Void)? {
		get {
			return lockOfHandlers.synchronized { _onFinishHandler }
		}
		set {
			lockOfHandlers.synchronized { _onFinishHandler = newValue }
		}
	}

	// MARK: -

	public override init() {
		super.init()
	}

	deinit {
		assert(true)
	}


	public final override func start() {
		if cancelled || finished || executing {
			return
		}
		willChangeValueForKey("isExecuting")
		lockOfProperties.synchronized { _executing = true }
		onStart()
		lockOfHandlers.synchronized { _onStartHandler?() }
		didChangeValueForKey("isExecuting")
	}

	public final override func cancel() {
		super.cancel()
		if executing {
			onCancel()
			lockOfHandlers.synchronized { _onCancelHandler?() }
			finish()
		} else {
			onCancel()
			lockOfHandlers.synchronized { _onCancelHandler?() }
			lockOfProperties.synchronized {
				_executing = false
				_finished = true
			}
		}
	}

	// MARK: - Internal

	public final func finish() {
		willChangeValueForKey("isExecuting")
		willChangeValueForKey("isFinished")
		lockOfProperties.synchronized {
			_executing = false
			_finished = true
		}
		onFinish()
		lockOfHandlers.synchronized { _onFinishHandler?() }
		didChangeValueForKey("isExecuting")
		didChangeValueForKey("isFinished")
	}

	// MARK: - Abstract

	/// Subclasses must launch job here.
	///
	/// **Note** called between willChangeValueForKey and didChangeValueForKey calls, but after property _executing is set.
	public func onStart() {
	}

	/// Subclasses must cancel job here.
	///
	/// **Note** called immediately after calling super.cancel().
	public func onCancel() {
	}

	/// Subclasses must release job here.
	///
	/// **Note** called between willChangeValueForKey and didChangeValueForKey calls,
	/// but after properties _executing and _finished are set.
	public func onFinish() {
	}

}
