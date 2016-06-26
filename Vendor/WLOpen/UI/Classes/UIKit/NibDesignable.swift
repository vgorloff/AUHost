/// File: NibDesignable.swift
/// Project: WLUI
/// Author: Created by Vlad Gorlov on 2014.09.12.
/// Copyright: Copyright (c) 2014 WaveLabs. All rights reserved.

import UIKit

/// @see http://justabeech.com/2014/07/27/xcode-6-live-rendering-from-nib/

@IBDesignable
public class NibDesignable: IBDesignableView {

	public var nibView: UIView!
	public var nibName: String {
		return self.dynamicType.description().componentsSeparatedByString(".").last!
	}
	/// Called to load the nib in setupNib().
	/// - returns: UIView instance loaded from a nib file.
	public func loadNib() -> UIView? {
		let bundle = NSBundle(forClass: self.dynamicType)
		let nib = UINib(nibName: nibName, bundle: bundle)
		return nib.instantiateWithOwner(self, options: nil).first as? UIView
	}

	public override func initializeView() {
		initializeNib()
	}

	private func initializeNib() {
		nibView = loadNib()
		assert(nibView != nil)
		nibView.frame = bounds
		nibView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
		addSubview(nibView)
	}
}
