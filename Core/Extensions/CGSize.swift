//
//  CGSize.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 21.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

public extension CGSize {

	func scaleToSize(newSize: CGSize) -> CGRect {
		guard !CGSizeEqualToSize(self, newSize) else {
			return CGRect(origin: CGPoint.zero, size: self)
		}
		let aspectWidth = newSize.width / width
		let aspectHeight = newSize.height / height
		let aspectRatio = min(aspectWidth, aspectHeight)

		var scaledRect = CGRect.zero
		scaledRect.size.width = width * aspectRatio
		scaledRect.size.height = height * aspectRatio
		scaledRect.origin.x = (newSize.width - scaledRect.size.width) / 2.0
		scaledRect.origin.y = (newSize.height - scaledRect.size.height) / 2.0
		return scaledRect
	}
	func cropToSize(newSize: CGSize) -> CGRect {
		guard !CGSizeEqualToSize(self, newSize) else {
			return CGRect(origin: CGPoint.zero, size: self)
		}
		let aspectWidth = newSize.width / width
		let aspectHeight = newSize.height / height
		let aspectRatio = max(aspectWidth, aspectHeight)

		var croppedRect = CGRect.zero
		croppedRect.size.width = width * aspectRatio
		croppedRect.size.height = height * aspectRatio
		croppedRect.origin.x = (newSize.width - croppedRect.size.width) / 2.0
		croppedRect.origin.y = (newSize.height - croppedRect.size.height) / 2.0
		return croppedRect
	}
	init(squareSide: CGFloat) {
		self.init(width: squareSide, height: squareSide)
	}
}
