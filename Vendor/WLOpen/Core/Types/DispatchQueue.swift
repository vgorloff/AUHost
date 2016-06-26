/// File: DispatchQueue.swift
/// Project: WLCore
/// Author: Created by Volodymyr Gorlov on 01.07.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

// Reusable properties for easy use.
// See [Grand Central Dispatch Tutorial for Swift: Part 1/2 - Ray Wenderlich]
// (http://www.raywenderlich.com/79149/grand-central-dispatch-tutorial-swift-part-1)

import Dispatch

public struct DispatchQueue {

	public static var Main: dispatch_queue_t {
		return dispatch_get_main_queue()
	}

	public static var UserInteractive: dispatch_queue_t {
		return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
	}

	public static var UserInitiated: dispatch_queue_t {
		return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
	}

	public static var Utility: dispatch_queue_t {
		return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
	}

	public static var Background: dispatch_queue_t {
		return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
	}

	public static var Serial: dispatch_queue_t {
		return dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
	}

	public static var Concurrent: dispatch_queue_t {
		return dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
	}

	public static func serial(label: String) -> dispatch_queue_t {
		return dispatch_queue_create(label, DISPATCH_QUEUE_SERIAL)
	}

	public static func concurrent(label: String) -> dispatch_queue_t {
		return dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT)
	}
}
