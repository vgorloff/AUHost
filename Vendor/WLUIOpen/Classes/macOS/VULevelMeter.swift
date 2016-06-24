//
//  VULevelMeter.swift
//  WLUI
//
//  Created by Vlad Gorlov on 26.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit

@IBDesignable
public final class VULevelMeter: NSView {

	public var numberOfChannels: UInt32 = 1
	public var level = Array<Float>(count: 1, repeatedValue: 0) {
		didSet {
			needsDisplay = true
			assert(UInt32(level.count) >= numberOfChannels)
		}
	}

	public override func drawRect(dirtyRect: NSRect) {
		let levelL = min(1, level[0]).CGFloatValue
		let rect = NSRect(origin: CGPoint.zero, size: CGSize(width: bounds.width * levelL, height: bounds.height))
		NSColor.redColor().setFill()
		NSRectFill(rect)
	}

}
