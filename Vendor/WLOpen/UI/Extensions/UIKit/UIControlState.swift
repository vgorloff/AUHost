//
//  UIControlState.swift
//  WLUI
//
//  Created by Vlad Gorlov on 21.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public extension UIControlState {
	var stringValue: String {
		if #available(iOS 9.0, *) {
		    switch self {
    		case UIControlState.Normal: return "Normal"
    		case UIControlState.Highlighted: return "Highlighted"
    		case UIControlState.Disabled: return "Disabled"
    		case UIControlState.Selected: return "Selected"
    		case UIControlState.Focused: return "Focused"
    		case UIControlState.Application: return "Application"
    		case UIControlState.Reserved: return "Reserved"
    		default: return "Unknown"
    		}
		} else {
			switch self {
			case UIControlState.Normal: return "Normal"
			case UIControlState.Highlighted: return "Highlighted"
			case UIControlState.Disabled: return "Disabled"
			case UIControlState.Selected: return "Selected"
			case UIControlState.Application: return "Application"
			case UIControlState.Reserved: return "Reserved"
			default: return "Unknown"
			}
		}
	}
}
