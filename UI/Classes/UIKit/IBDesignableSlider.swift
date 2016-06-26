//
//  IBDesignableSlider.swift
//  WLUI
//
//  Created by Vlad Gorlov on 17.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public class IBDesignableSlider: UISlider {

	public override init(frame: CGRect) {
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
