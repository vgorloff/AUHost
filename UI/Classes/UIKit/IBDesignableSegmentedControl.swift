//
//  IBDesignableSegmentedControl.swift
//  WLUI
//
//  Created by Volodymyr Gorlov on 30.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import UIKit

public class IBDesignableSegmentedControl: UISegmentedControl {

	override init(items: [AnyObject]?) {
		super.init(items: items)
		#if !TARGET_INTERFACE_BUILDER
			initializeView()
		#endif
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		#if !TARGET_INTERFACE_BUILDER
			initializeView()
		#endif
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	public override func awakeFromNib() {
		super.awakeFromNib()
		initializeView()
	}

	public override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		initializeView()
	}

	/// Called after all KVC properties are settled.
	public func initializeView() {
		// Do something
	}

}
