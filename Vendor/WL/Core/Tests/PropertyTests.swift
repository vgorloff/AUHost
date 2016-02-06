//
//  PropertyTests.swift
//  WLCore
//
//  Created by Vlad Gorlov on 03.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import XCTest
#if os(iOS)
	import WaveLabsiOS
#elseif os(OSX)
	import WaveLabsOSX
#endif

class PropertyTests: XCTestCase {

	private let numberOfIterations = 1_000_000

	func measureWithName(name: String, property: Property<Bool>) {
		let res = benchmark {
			for _ in 0..<numberOfIterations {
				let v = property.value
				property.value = !v
			}
		}
		print("~~~> \(name) takes: \(res) seconds.")
	}

	func testSpinLock() {
		let p = Property(true, lock: SpinLock())
		measureBlock { [weak self] in
			self?.measureWithName("SpinLock", property: p)
		}
	}

	func testNonRecursiveMutex() {
		let p = Property(true, lock: NonRecursiveMutex())
		measureBlock { [weak self] in
			self?.measureWithName("NonRecursiveMutex", property: p)
		}
	}

}
