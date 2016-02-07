//
//  AudioUnitTests.swift
//  WLMedia
//
//  Created by Vlad Gorlov on 14.01.16.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import XCTest
import AVFoundation
import FilterDemoFramework

private func WLRegisterAU() {
}

class AudioUnitTests: GenericTestCase {

	override func setUp() {
		super.setUp()
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testInit() {
		var componentDescription = AudioComponentDescription()
		componentDescription.componentType = kAudioUnitType_Effect
		componentDescription.componentSubType = "fltr".OSTypeValue // 0x666c7472 /*'fltr'*/
		componentDescription.componentManufacturer = "Demo".OSTypeValue // = 0x44656d6f /*'Demo'*/
		componentDescription.componentFlags = 0
		componentDescription.componentFlagsMask = 0

		/*
		Register our `AUAudioUnit` subclass, `AUv3FilterDemo`, to make it able
		to be instantiated via its component description.

		Note that this registration is local to this process.
		*/
		AUAudioUnit.registerSubclass(AUv3FilterDemo.self, asComponentDescription: componentDescription, name: "Local FilterDemo", version: 2)
		do {
			let au = try AUAudioUnit(componentDescription: componentDescription, options: [.LoadInProcess])
			print(au.audioUnitName, au.manufacturerName)
		} catch {
			print(error)
		}
	}

	func testAUNodeInit() {
		var componentDescription = AudioComponentDescription()
		componentDescription.componentType = kAudioUnitType_Effect
		componentDescription.componentSubType = "fltr".OSTypeValue // 0x666c7472 /*'fltr'*/
		componentDescription.componentManufacturer = "Demo".OSTypeValue // = 0x44656d6f /*'Demo'*/
		componentDescription.componentFlags = 0
		componentDescription.componentFlagsMask = 0
		let x = expectationWithDescription("X")
		AVAudioUnit.instantiateWithComponentDescription(componentDescription, options: [.LoadInProcess]) { avAudioUnit, error in
			if let e = error {
				print(e)
			}
			if let effect = avAudioUnit {
				print(effect.name, effect.manufacturerName)
			}
			x.fulfill()
		}

		waitForExpectationsWithTimeout(180, handler: nil)
	}

	func testExample() {
		var anyEffectDescription = AudioComponentDescription()
		anyEffectDescription.componentType = kAudioUnitType_Effect
		anyEffectDescription.componentSubType = 0
		anyEffectDescription.componentManufacturer = 0
		anyEffectDescription.componentFlags = 0
		anyEffectDescription.componentFlagsMask = 0

		let effects = AVAudioUnitComponentManager.sharedAudioUnitComponentManager()
			.componentsMatchingDescription(anyEffectDescription)
		for effect in effects {
			print(effect.name, effect.manufacturerName)
		}
	}

}
