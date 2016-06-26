//
//  TestViewController.swift
//  WLUI
//
//  Created by Vlad Gorlov on 24.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import UIKit.UIViewController

public final class TestViewController: UIViewController {

	private lazy var _labelOfMessage: UILabel = self.setUpLabelOfMessage()
	public var labelOfMessage: UILabel {
		return _labelOfMessage
	}

	public init() {
		super.init(nibName: nil, bundle: nil)
	}

	public required init?(coder aDecoder: NSCoder) {
	   super.init(coder: aDecoder)
	}

	public override func loadView() {
		let v = UIView()
		v.backgroundColor = UIColor.grayColor()
		v.addSubview(labelOfMessage)
		let cH = NSLayoutConstraint.constraintsWithVisualFormat("|[subview]|",
			options: [], metrics: nil, views:["subview": labelOfMessage])
		let cV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[subview]|",
			options: [], metrics: nil, views:["subview": labelOfMessage])
		v.addConstraints(cH)
		v.addConstraints(cV)
		view = v
	}

	private func setUpLabelOfMessage() -> UILabel {
		let l = UILabel()
		l.text = "Running tests ..."
		l.textColor = UIColor.whiteColor()
		if #available(iOS 8.2, *) {
			l.font = UIFont.systemFontOfSize(32, weight: UIFontWeightThin)
		} else {
			l.font = UIFont.systemFontOfSize(32)
		}
		l.textAlignment = .Center
		l.translatesAutoresizingMaskIntoConstraints = false
		l.numberOfLines = 0
		return l
	}

}
