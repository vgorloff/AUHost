//
//  NSViewController.swift
//  WLUI
//
//  Created by Vlad Gorlov on 03.01.18.
//  Copyright © 2018 Demo. All rights reserved.
//

import AppKit
import mcUI

extension NSViewController {

   public func loadViewIfNeeded() {
      if !isViewLoaded {
         loadView()
      }
   }

   public func embedChildViewController(_ vc: NSViewController, container: NSView? = nil) {
      addChild(vc)
      let targetView = container ?? view
      // Fix for possible layout issues. Origin: https://stackoverflow.com/a/49255958/1418981
      var frame = CGRect(x: 0, y: 0, width: targetView.frame.width, height: targetView.frame.height)
      if frame.size.width == 0 {
         frame.size.width = CGFloat.leastNormalMagnitude
      }
      if frame.size.height == 0 {
         frame.size.height = CGFloat.leastNormalMagnitude
      }
      vc.view.frame = frame
      vc.view.autoresizingMask = [.height, .width]
      targetView.addSubview(vc.view)
   }

   public func unembedChildViewController(_ vc: NSViewController) {
      vc.view.removeFromSuperview()
      vc.removeFromParent()
   }

   public var systemAppearance: SystemAppearance {
      return view.systemAppearance
   }
}

extension FailureReporting where Self: NSViewController {

   public func reportFailure(error: Swift.Error) {
      log.error(.controller, error)
      presentError(error)
   }
}
