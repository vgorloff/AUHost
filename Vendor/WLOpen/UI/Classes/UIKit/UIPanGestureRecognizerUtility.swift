//
//  UIPanGestureRecognizerUtility.swift
//  WLUI
//
//  Created by Vlad Gorlov on 02.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public final class UIPanGestureRecognizerUtility: NSObject, UIGestureRecognizerDelegate {
	@IBOutlet public weak var gestureRecognizer: UIPanGestureRecognizer! {
		didSet {
		if view != nil {
			view.addGestureRecognizer(gestureRecognizer)
		}
		gestureRecognizer.addTarget(self, action: #selector(handleGesture(_:)))
		}
	}
	@IBOutlet public weak var view: UIView! {
		didSet {
		if gestureRecognizer != nil {
			view.addGestureRecognizer(gestureRecognizer)
		}
		}
	}
	public var handleDidChangeState: (UIGestureRecognizerState -> Void)?
	public private(set) var location = ValueHistory<CGPoint>(CGPoint.zero)
	@objc private func handleGesture(sender: UIPanGestureRecognizer) {
		guard sender == gestureRecognizer && gestureRecognizer.view == view else {
			return
		}

		switch gestureRecognizer.state {
		case .Possible: break
		case .Began:
			location.reset(sender.locationInView(view))
		case .Changed:
			location.current = sender.locationInView(view)
		case .Ended, .Cancelled, .Failed:
			location.reset(CGPoint.zero)
		}
		handleDidChangeState?(gestureRecognizer.state)
	}
}
