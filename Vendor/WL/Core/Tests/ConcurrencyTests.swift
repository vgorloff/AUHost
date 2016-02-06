//
//  ConcurrencyTests.swift
//  WLCore
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import XCTest
#if os(iOS)
	import WaveLabsiOS
#elseif os(OSX)
	import WaveLabsOSX
#endif

/// - SeeAlso: http://perpendiculo.us/2009/09/synchronized-nslock-pthread-osspinlock-showdown-done-right/
class ConcurrencyTests: XCTestCase {

	private let numberOfIterations = 10_000_000

	func measureWithName(name: String, lock: NonRecursiveLocking) {
		let res = benchmark {
			for _ in 0..<numberOfIterations {
				lock.synchronized {
					noop()
				}
			}
		}
		print("~~~> \(name) takes: \(res) seconds.")
	}

	func testSpinLock() {
		measureBlock { [weak self] in
			self?.measureWithName("SpinLock", lock: SpinLock())
		}
	}

	func testNonRecursiveMutex() {
		measureBlock { [weak self] in
			self?.measureWithName("NonRecursiveMutex", lock: NonRecursiveMutex())
		}
	}

	func testNSLocker() {
		measureBlock { [weak self] in
			self?.measureWithName("NSLocker", lock: NSLocker())
		}
	}

	func testObjCSync() {
		measureBlock { [weak self] in
			self?.measureWithName("ObjCSync", lock: ObjCSync())
		}
	}

	// Too slow
	/*
	func testDispatchLock() {
		let lock = DispatchLock()
		measureBlock { [weak self] in
			guard let s = self else { return }
			let res = benchmark {
				for _ in 0..<s.numberOfIterations {
					lock.synchronized {
						noop()
					}
				}
			}
			print("~~~> DispatchLock takes: \(res) seconds.")
		}
	}
	*/

}
