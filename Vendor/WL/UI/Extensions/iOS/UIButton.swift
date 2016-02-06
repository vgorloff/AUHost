//
//  UIButton.swift
//  WLUI
//
//  Created by Volodymyr Gorlov on 04.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public extension UIButton {

	func setTitleColor(color: UIColor?, forStates states: [UIControlState]) {
		for state in states {
			setTitleColor(color, forState: state)
		}
	}
}
