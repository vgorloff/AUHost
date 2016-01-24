//
//  AttenuatorViewController.swift
//  AttenuatorAU
//
//  Created by Volodymyr Gorlov on 14.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreAudioKit
import AVFoundation

public class AttenuatorViewController: AUViewController, AUAudioUnitFactory {
	var audioUnit: AUAudioUnit!

	public override func loadView() {
		var topLevelObjects: NSArray?
		guard
			let nib = NSNib(nibNamed: String(AttenuatorViewController.self), bundle: NSBundle(forClass: AttenuatorViewController.self)) where
			nib.instantiateWithOwner(self, topLevelObjects: &topLevelObjects), let objects = topLevelObjects else {
				fatalError()
		}
		for object in objects {
			if let v = object as? NSView {
				view = v
				return
			}
		}
		fatalError()
	}

	public override func viewDidLoad() {
		super.viewDidLoad()

		if audioUnit == nil {
			return
		}

		// Get the parameter tree and add observers for any parameters that the UI needs to keep in sync with the AudioUnit
	}

	public func createAudioUnitWithComponentDescription(componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
		audioUnit = try AttenuatorAudioUnit(componentDescription: componentDescription, options: [])
		return audioUnit
	}

}
