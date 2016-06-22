//
//  CGFloatRepresentable.swift
//  WLCore
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

public protocol CGFloatRepresentable {
	var CGFloatValue: CGFloat { get } // swiftlint:disable:this variable_name
}

extension Int: CGFloatRepresentable {
	public var CGFloatValue: CGFloat { // swiftlint:disable:this variable_name
		return CGFloat(self)
	}
}

extension Float: CGFloatRepresentable {
	public var CGFloatValue: CGFloat { // swiftlint:disable:this variable_name
		return CGFloat(self)
	}
}

