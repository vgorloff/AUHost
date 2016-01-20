//
//  Float.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

// swiftlint:disable variable_name
public protocol CGFloatConvertible {
	var CGFloatValue: CGFloat { get }
}

extension Float: CGFloatConvertible {
	public var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
}

extension Double: CGFloatConvertible {
	public var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
}

extension Int: CGFloatConvertible {
	public var CGFloatValue: CGFloat {
		return CGFloat(self)
	}
}
// swiftlint:enable variable_name
