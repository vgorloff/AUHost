//
//  UIViewLayoutAnimator.swift
//  WLUI
//
//  Created by Vlad Gorlov on 03.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public final class UIViewLayoutAnimator {
	public var defaultDuration: NSTimeInterval = 0.2
	public var configureConstraints: ((forward: Bool) -> Void)?
	public var animations: (Void -> Void)?
	public var completion: ((forward: Bool, completed: Bool) -> Void)?
	private var view: UIView
	public init (view aView: UIView) {
		view = aView
	}
	public func animate(forward forward: Bool, duration aDuration: NSTimeInterval = -1) {
		let duration = aDuration > 0 ? aDuration : defaultDuration
		configureConstraints?(forward: forward)
		UIView.animateWithDuration(duration, animations: { [weak self] in self?.performAnimations() }) {[weak self] completed in
			self?.performCompletion(forward, completed: completed)
		}
	}
	private func performAnimations() {
		animations?()
		view.layoutIfNeeded()
	}
	private func performCompletion(forward: Bool, completed: Bool) {
		completion?(forward: forward, completed: completed)
	}
}
