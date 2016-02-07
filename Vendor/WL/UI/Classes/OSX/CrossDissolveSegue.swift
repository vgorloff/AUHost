//
//  CrossDissolveSegue.swift
//  WLUI
//
//  Created by Vlad Gorlov on 28.03.15.
//  Copyright (c) 2015 WaveLabs. All rights reserved.
//

import AppKit

public class CrossDissolveSegue: NSStoryboardSegue {
	override public func perform() {
      guard let c = destinationController as? NSViewController else {
         fatalError("destinationController is not type of NSViewController")
      }
      sourceController.presentViewController(c, animator: CrossDissolveAnimator(animationDuration: 0.25))
	}
}

class CrossDissolveAnimator: NSObject, NSViewControllerPresentationAnimator {

	private var animationDuration = 0.25

	convenience init(animationDuration aDuration: NSTimeInterval) {
		self.init()
		animationDuration = aDuration
	}

	func animatePresentationOfViewController(toViewController: NSViewController, fromViewController: NSViewController) {

		toViewController.view.wantsLayer = true
		toViewController.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
		toViewController.view.alphaValue = 0
		toViewController.view.translatesAutoresizingMaskIntoConstraints = false
		toViewController.view.autoresizingMask = []

		fromViewController.view.addSubview(toViewController.view)
		toViewController.view.frame = fromViewController.view.frame
		let constraintsH = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil,
			views: ["view": toViewController.view])
		let constraintsV = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil,
			views: ["view": toViewController.view])
		fromViewController.view.addConstraints(constraintsH + constraintsV)

		NSAnimationContext.runAnimationGroup({ [weak self] context in
			guard let s = self else {
				return
			}
			context.duration = s.animationDuration
			toViewController.view.animator().alphaValue = 1
			}, completionHandler: nil)
	}

	func animateDismissalOfViewController(viewController: NSViewController, fromViewController: NSViewController) {

		viewController.view.wantsLayer = true
		viewController.view.layerContentsRedrawPolicy = .OnSetNeedsDisplay

		NSAnimationContext.runAnimationGroup({ [weak self] (context) -> Void in
			guard let s = self else {
				return
			}
			context.duration = s.animationDuration
			viewController.view.animator().alphaValue = 0
			}, completionHandler: {
				viewController.view.removeFromSuperview()
		})
	}

}
