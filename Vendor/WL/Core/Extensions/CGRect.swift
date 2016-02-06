//
//  CGRect.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 21.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

public extension CGRect {
	func scaleToSize(newSize: CGSize) -> CGRect {
		guard !CGSizeEqualToSize(size, newSize) else {
			return self
		}
		let aspectWidth = newSize.width / size.width
		let aspectHeight = newSize.height / size.height
		let aspectRatio = min(aspectWidth, aspectHeight)

		var scaledRect = CGRect.zero
		scaledRect.size.width = size.width * aspectRatio
		scaledRect.size.height = size.height * aspectRatio
		scaledRect.origin.x = (newSize.width - scaledRect.size.width) / 2.0
		scaledRect.origin.y = (newSize.height - scaledRect.size.height) / 2.0
		return scaledRect
	}
	func cropToSize(newSize: CGSize) -> CGRect {
		guard !CGSizeEqualToSize(size, newSize) else {
			return self
		}
		let aspectWidth = newSize.width / size.width
		let aspectHeight = newSize.height / size.height
		let aspectRatio = max(aspectWidth, aspectHeight)

		var croppedRect = CGRect.zero
		croppedRect.size.width = size.width * aspectRatio
		croppedRect.size.height = size.height * aspectRatio
		croppedRect.origin.x = (newSize.width - croppedRect.size.width) / 2.0
		croppedRect.origin.y = (newSize.height - croppedRect.size.height) / 2.0
		return croppedRect
	}
}
