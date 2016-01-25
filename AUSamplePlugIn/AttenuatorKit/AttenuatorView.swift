//
//  AttenuatorView.swift
//  Attenuator
//
//  Created by Vlad Gorlov on 25.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Cocoa
import AudioUnit

class AttenuatorView: NSView {

	@IBOutlet private weak var sliderGain: NSSlider!

	var handlerParameterDidChaned: ((AttenuatorParameter, AUValue) -> Void)?

	func updateParameter(parameter: AttenuatorParameter, withValue: AUValue) {
		sliderGain.floatValue = withValue
	}

	@IBAction private func handleGainChange(sender: NSSlider) {
		handlerParameterDidChaned?(AttenuatorParameter.Gain, sender.floatValue)
	}
}
