//
//  UIControlStateSet.swift
//  WLUI
//
//  Created by Vlad Gorlov on 21.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

func UIControlStateSetGetStates() -> [UIControlState] {
	if #available(iOS 9.0, *) {
		return [.Normal, .Highlighted, .Disabled, .Selected, .Focused]
	} else {
		return [.Normal, .Highlighted, .Disabled, .Selected]
	}
}

public struct UIControlStateSet<T> {
	public let states = UIControlStateSetGetStates()
	public var values: [String: T]
	public var normal: T? {
		return values[UIControlState.Normal.stringValue]
	}
	public var highlighted: T? {
		return values[UIControlState.Highlighted.stringValue]
	}
	public var disabled: T? {
		return values[UIControlState.Disabled.stringValue]
	}
	public var selected: T? {
		return values[UIControlState.Selected.stringValue]
	}
	@available(iOS 9.0, *)
	public var focused: T? {
		return values[UIControlState.Normal.stringValue]
	}

	public init(normal: T? = nil, highlighted: T? = nil, disabled: T? = nil, selected: T? = nil, focused: T? = nil) {
		var values = [String: T]()
		if let value = normal {
			values[UIControlState.Normal.stringValue] = value
		}
		if let value = highlighted {
			values[UIControlState.Highlighted.stringValue] = value
		}
		if let value = disabled {
			values[UIControlState.Disabled.stringValue] = value
		}
		if let value = selected {
			values[UIControlState.Selected.stringValue] = value
		}
		if #available(iOS 9.0, *) {
			if let value = focused {
				values[UIControlState.Focused.stringValue] = value
			}
		}
		self.values = values
	}

}
