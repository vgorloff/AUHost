//
//  CGRect.swift
//  WLUI
//
//  Created by Volodymyr Gorlov on 21.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics
import WLCore

#if os(iOS)
import UIKit
#endif

#if os(iOS)
extension CGRect: StringRepresentable {
	public var stringValue: String {
		return NSStringFromCGRect(self)
	}
}
#endif
