//
//  UIViewLayoutAnimator.swift
//  WLUI
//
//  Created by Vlad Gorlov on 03.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import UIKit

public final class UIViewLayoutAnimator {

	public var setUp: ((forward: Bool) -> Void)?
	public var animations: ((forward: Bool) -> UIView?)?
	public var tearDown: ((forward: Bool, completed: Bool) -> Void)?

	public init() {

	}
	
	public func animate(forward forward: Bool, withDuration d: NSTimeInterval = 0.2) {
		setUp?(forward: forward)
		UIView.animateWithDuration(d, animations: { [weak self] in
			self?.performAnimations(forward) }
		) {[weak self] completed in
			self?.performCompletion(forward, completed: completed)
		}
	}

	// MARK: - Private
	private func performAnimations(forward: Bool) {
		let view = animations?(forward: forward)
		view?.layoutIfNeeded()
	}

	private func performCompletion(forward: Bool, completed: Bool) {
		tearDown?(forward: forward, completed: completed)
	}
}
