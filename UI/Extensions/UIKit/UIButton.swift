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

	static func autolayoutButton(buttonType: UIButtonType = .Custom) -> UIButton {
		let view = UIButton(type: buttonType)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}
	func setTitleColors(colorSet: UIControlStateSet<UIColor>) {
		for state in colorSet.states {
			if let value = colorSet.values[state.stringValue] {
				setTitleColor(value, forState: state)
			}
		}
	}
	func setAttributedTitles(titlesSet: UIControlStateSet<NSAttributedString>) {
		for state in titlesSet.states {
			if let value = titlesSet.values[state.stringValue] {
				setAttributedTitle(value, forState: state)
			}
		}
	}
	func setImages(imageSet: UIControlStateSet<UIImage>) {
		for state in imageSet.states {
			if let value = imageSet.values[state.stringValue] {
				setImage(value, forState: state)
			}
		}
	}
}
