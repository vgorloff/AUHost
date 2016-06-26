/// File: UIImage.swift
/// Project: WLUI
/// Author: Created by Volodymyr Gorlov on 23.02.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import UIKit

private func DrawInImageContextWithSize(size: CGSize, hasAlpha: Bool = true, scale: CGFloat = 0,
	@noescape drawingCalls: Void -> Void) -> UIImage {
	UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
	drawingCalls()
	let newImage = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	return newImage
}

/// - SeeAlso: [https://github.com/mbcharbonneau/UIImage-Categories/blob/master/UIImage%2BAlpha.m]
public extension UIImage {

	var hasAlpha: Bool {
		let alpha = CGImageGetAlphaInfo(CGImage)
		return (
			alpha == CGImageAlphaInfo.First ||
				alpha == CGImageAlphaInfo.Last ||
				alpha == CGImageAlphaInfo.PremultipliedFirst ||
				alpha == CGImageAlphaInfo.PremultipliedLast)
	}

	func scaleImageByFactor(scaleFactor: CGFloat) -> UIImage {
		let newSize = CGSizeApplyAffineTransform(size, CGAffineTransformMakeScale(scaleFactor, scaleFactor))
		return DrawInImageContextWithSize(newSize, hasAlpha: hasAlpha) {
			let rect = CGRect(origin: CGPoint.zero, size: newSize)
			drawInRect(rect)
		}
	}

	func scaleImageToSize(newSize: CGSize, fillColor aColor: UIColor? = nil) -> UIImage {
		return DrawInImageContextWithSize(newSize, hasAlpha: newSize != size || aColor != nil) {
			if let fillColor = aColor {
				fillColor.setFill()
				UIRectFill(CGRect(origin: CGPoint.zero, size: newSize))
			}
			let rect = size.scaleToSize(newSize)
			drawInRect(rect)
		}
	}

	func cropImageToSize(newSize: CGSize) -> UIImage {
		return DrawInImageContextWithSize(newSize, hasAlpha: newSize != size) {
			drawInRect(size.cropToSize(newSize))
		}
	}

	convenience init(size: CGSize, fillColor: UIColor, rounded: Bool = false) {
		let image = DrawInImageContextWithSize(size, hasAlpha: rounded) {
			let rect = CGRect(origin:CGPoint.zero, size: size)
			if rounded {
				let radius = min(size.height, size.width)
				UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
			}
			fillColor.setFill()
			UIRectFill(rect)
		}
		self.init(CGImage: image.CGImage!)
	}

	var roundedImage: UIImage {
		return DrawInImageContextWithSize(size, hasAlpha: true) {
			let rect = CGRect(origin: CGPoint.zero, size: size)
			let radius = min(size.height, size.width)
			UIBezierPath(roundedRect: rect, cornerRadius: radius).addClip()
			drawInRect(rect)
		}
	}

	/// Instantiate UIImage or nil if data is nil or image canot be instantiated.
	/// - parameter dataOrNil: Image data or nil.
	convenience init?(dataOrNil: NSData?) {
		if let d = dataOrNil {
			self.init(data: d)
		} else {
			return nil
		}
	}

	static func imageSetWithBaseName(baseName: String, stateSuffixSeparator: String = "-", bundle: NSBundle? = nil,
		compatibleWithTraitCollection traitCollection: UITraitCollection? = nil) -> UIControlStateSet<UIImage> {
			var controlState = UIControlStateSet<UIImage>()
			for state in controlState.states {
				let imageKey = state.stringValue
				let imageAssetName = baseName + stateSuffixSeparator + imageKey
				if let image = UIImage(named: imageAssetName, inBundle: bundle, compatibleWithTraitCollection: traitCollection) {
					controlState.values[imageKey] = image
				}
			}
			return controlState
	}
}
