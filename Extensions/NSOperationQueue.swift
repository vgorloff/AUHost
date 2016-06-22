//
//  NSOperationQueue.swift
//  WLCore
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension NSOperationQueue {

	public struct UserInteractive {
		public static func NonConcurrent(name: String? = nil) -> NSOperationQueue {
			let q = Concurrent(name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> NSOperationQueue {
			let q = NSOperationQueue()
			q.qualityOfService = .UserInteractive
			q.name = name
			return q
		}
	}

	public struct UserInitiated {
		public static func NonConcurrent(name: String? = nil) -> NSOperationQueue {
			let q = Concurrent(name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> NSOperationQueue {
			let q = NSOperationQueue()
			q.qualityOfService = .UserInitiated
			q.name = name
			return q
		}
	}

	public struct Utility {
		public static func NonConcurrent(name: String? = nil) -> NSOperationQueue {
			let q = Concurrent(name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> NSOperationQueue {
			let q = NSOperationQueue()
			q.qualityOfService = .Utility
			q.name = name
			return q
		}
	}

	public struct Background {
		public static func NonConcurrent(name: String? = nil) -> NSOperationQueue {
			let q = Concurrent(name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> NSOperationQueue {
			let q = NSOperationQueue()
			q.qualityOfService = .Background
			q.name = name
			return q
		}
	}

	public struct Default {
		public static func NonConcurrent(name: String? = nil) -> NSOperationQueue {
			let q = Concurrent(name)
			q.maxConcurrentOperationCount = 1
			return q
		}
		public static func Concurrent(name: String? = nil) -> NSOperationQueue {
			let q = NSOperationQueue()
			q.qualityOfService = .Default
			q.name = name
			return q
		}
	}

	public struct NonConcurrent {
		public static func UserInteractive(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.UserInteractive.NonConcurrent(name)
		}
		public static func UserInitiated(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.UserInitiated.NonConcurrent(name)
		}
		public static func Utility(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.Utility.NonConcurrent(name)
		}
		public static func Background(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.Background.NonConcurrent(name)
		}
		public static func Default(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.Default.NonConcurrent(name)
		}
	}

	public struct Concurrent {
		public static func UserInteractive(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.UserInteractive.Concurrent(name)
		}
		public static func UserInitiated(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.UserInitiated.Concurrent(name)
		}
		public static func Utility(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.Utility.Concurrent(name)
		}
		public static func Background(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.Background.Concurrent(name)
		}
		public static func Default(name: String? = nil) -> NSOperationQueue {
			return NSOperationQueue.Default.Concurrent(name)
		}
	}

}
