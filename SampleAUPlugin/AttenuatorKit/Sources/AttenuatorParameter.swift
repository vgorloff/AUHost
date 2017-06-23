//
//  AttenuatorParameter.swift
//  Attenuator
//
//  Created by Volodymyr Gorlov on 22.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AudioUnit

enum AttenuatorParameter: UInt64 {
	case gain = 1000
	static func fromRawValue(_ rawValue: UInt64) -> AttenuatorParameter {
		if let value = AttenuatorParameter.init(rawValue: rawValue) {
			return value
		}
		fatalError()
	}
	var parameterID: String {
		let prefix = "paramID:"
		switch self {
		case .gain: return prefix + "Gain"
		}
	}
	var name: String {
		switch self {
		case .gain: return "Gain"
		}
	}
	var min: AUValue {
		switch self {
		case .gain: return 0
		}
	}
	var max: AUValue {
		switch self {
		case .gain: return 100
		}
	}
	var defaultValue: AUValue {
		switch self {
		case .gain: return 100
		}
	}
	func stringFromValue(value: AUValue) -> String {
		switch self {
		case .gain: return "\(value)"
		}
	}
}
