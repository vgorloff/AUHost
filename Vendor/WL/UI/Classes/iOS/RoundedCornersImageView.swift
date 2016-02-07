//
//  RoundedCornersImageView.swift
//  WLUI
//
//  Created by Vlad Gorlov on 04.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public class RoundedCornersImageView: IBDesignableImageView {

	public override func layoutSubviews() {
		super.layoutSubviews()
		let radius = 0.5 * min(CGRectGetHeight(bounds), CGRectGetWidth(bounds))
		layer.cornerRadius = radius
		layer.masksToBounds = radius > 0
	}

}
