//
//  UIImageView.swift
//  WLUI
//
//  Created by Volodymyr Gorlov on 21.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public extension UIImageView {

	private struct AssociatedKeys {
		static var PlaceholderImage = "awl_placeholderImage"
	}
	public var placeholderImage: UIImage? {
		get {
			return ObjCAssociation.getValue(self, key: &AssociatedKeys.PlaceholderImage)
		}
		set {
			ObjCAssociation.setValueRetain(self, key: &AssociatedKeys.PlaceholderImage, value: newValue)
		}
	}
}
