//
//  UISegmentedControl.swift
//  WLUI
//
//  Created by Volodymyr Gorlov on 04.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public extension UISegmentedControl {

	public func setBackgroundImage(backgroundImage: UIImage?, forStates states: [UIControlState], barMetrics: UIBarMetrics) {
		for state in states {
			setBackgroundImage(backgroundImage, forState: state, barMetrics: barMetrics)
		}
	}

	public func setDividerImageForAllStates(dividerImage: UIImage?, barMetrics: UIBarMetrics) {
		setDividerImage(dividerImage, forLeftSegmentState: .Normal, rightSegmentState: .Normal, barMetrics: barMetrics)
		setDividerImage(dividerImage, forLeftSegmentState: .Normal, rightSegmentState: .Selected, barMetrics: barMetrics)
		setDividerImage(dividerImage, forLeftSegmentState: .Selected, rightSegmentState: .Normal, barMetrics: barMetrics)
	}

	public func setTitleTextAttributes(textAttributes: [NSObject : AnyObject]?, forStates states: [UIControlState]) {
		for state in states {
			setTitleTextAttributes(textAttributes, forState: state)
		}
	}
}
