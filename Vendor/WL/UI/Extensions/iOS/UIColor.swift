/// File: UIColor.swift
/// Project: WLUI
/// Author: Created by Vlad Gorlov on 23.02.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import UIKit

public extension UIColor {

	public var lighterColor: UIColor {
		var r = CGFloat(0)
		var g = CGFloat(0)
		var b = CGFloat(0)
		var a = CGFloat(0)
		if getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: min(r + 0.2, 1.0), green: min(g + 0.2, 1.0), blue: min(b + 0.2, 1.0), alpha: a)
		} else {
			assert(false, "Unable to get lighter color for color: \(self)")
			return self
		}
	}

	public var darkerColor: UIColor {
		var r = CGFloat(0)
		var g = CGFloat(0)
		var b = CGFloat(0)
		var a = CGFloat(0)
		if getRed(&r, green: &g, blue: &b, alpha: &a) {
			return UIColor(red: min(r - 0.2, 1.0), green: min(g - 0.2, 1.0), blue: min(b - 0.2, 1.0), alpha: a)
		} else {
			assert(false, "Unable to get lighter color for color: \(self)")
			return self
		}
	}

}
