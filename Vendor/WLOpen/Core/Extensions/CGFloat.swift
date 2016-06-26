//
//  CGFloat.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 06.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

extension CGFloat: FloatRepresentable {
	public var floatValue: Float {
		return Float(self)
	}
}
