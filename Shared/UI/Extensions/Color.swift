//
//  CommonExtensions.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 04.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics
#if os(iOS)
	import UIKit
	public typealias ColorType = UIColor
#elseif os(OSX)
	import AppKit
	public typealias ColorType = NSColor
#endif

public extension ColorType {

	public convenience init(hexValue hex: UInt64) {
		let R = CGFloat((hex & 0xFF0000) >> 16) / 255.0
		let G = CGFloat((hex & 0xFF00) >> 8) / 255.0
		let B = CGFloat(hex & 0xFF) / 255.0
		self.init(red: R, green: G, blue: B, alpha: 1)
	}

	public convenience init?(hexString: String) {
		let scanner = Scanner(string:
      hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
		guard scanner.scanString("#", into: nil) else {
			return nil
		}
		guard (scanner.string.characters.count - scanner.scanLocation) == 6 else {
			return nil
		}
		var hexNumber: UInt64 = 0
		if scanner.scanHexInt64(&hexNumber) {
			self.init(hexValue: hexNumber)
			return
		}
		return nil
	}

	public convenience init?(rgba: String, rgbCompomentsIn256Range: Bool = false) {
		var rgbaValue = rgba.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		rgbaValue = rgbaValue.lowercased()
		let scanner = Scanner(string: rgbaValue)
		guard scanner.scanString("rgba(", into: nil) else {
			return nil
		}
		var r: Float = 0
		var g: Float = 0
		var b: Float = 0
		var a: Float = 0
		guard
			scanner.scanFloat(&r) && scanner.scanString(",", into: nil) &&
				scanner.scanFloat(&g) && scanner.scanString(",", into: nil) &&
				scanner.scanFloat(&b) && scanner.scanString(",", into: nil) &&
				scanner.scanFloat(&a) && scanner.scanString(")", into: nil) else {
					return nil
		}
		if rgbCompomentsIn256Range {
			r /= 255.0
			g /= 255.0
			b /= 255.0
		}
		assert(r <= 1 && g <= 1 && b <= 1 && a <= 1)
		self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
	}

}
