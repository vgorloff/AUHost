//
//  FullContentWindowController.swift
//  mcmacOS-macOS
//
//  Created by Vlad Gorlov on 13.10.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import AppKit
import mcUI

open class FullContentWindowController: WindowController {

   private let fullContentWindow: FullContentWindow
   private let fullContentViewController = ViewController()

   public private(set) lazy var titleBarContentContainer = View().autolayoutView()
   public private(set) lazy var contentContainer = View().autolayoutView()

   private lazy var titleOffsetConstraint =
      titleBarContentContainer.leadingAnchor.constraint(equalTo: fullContentViewController.contentView.leadingAnchor)

   public init(contentRect: CGRect, titleBarHeight: CGFloat, titleBarLeadingOffset: CGFloat? = nil) {
      fullContentWindow = FullContentWindow(contentRect: contentRect, titleBarHeight: titleBarHeight,
                                            titleBarLeadingOffset: titleBarLeadingOffset)
      super.init(window: fullContentWindow, viewController: fullContentViewController)
      contentWindow.delegate = self
      fullContentViewController.contentView.addSubviews(titleBarContentContainer, contentContainer)

      let standardWindowButtonsRect = fullContentWindow.standardWindowButtonsRect

      LayoutConstraint.withFormat("V:|[*][*]|", titleBarContentContainer, contentContainer).activate()
      LayoutConstraint.pin(to: .horizontally, contentContainer).activate()
      LayoutConstraint.constrainHeight(constant: standardWindowButtonsRect.height, titleBarContentContainer).activate()
      LayoutConstraint.withFormat("[*]|", titleBarContentContainer).activate()
      titleOffsetConstraint.activate()

      titleOffsetConstraint.constant = standardWindowButtonsRect.maxX
   }

   open override func prepareForInterfaceBuilder() {
      titleBarContentContainer.backgroundColor = .green
      contentContainer.backgroundColor = .yellow
      fullContentViewController.contentView.backgroundColor = .blue
      fullContentWindow.titleBarAccessoryViewController.contentView.backgroundColor = NSColor.red.withAlphaComponent(0.4)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }
}

extension FullContentWindowController {

   public func embedTitleBarContent(_ viewController: NSViewController) {
      fullContentViewController.embedChildViewController(viewController, container: titleBarContentContainer)
   }

   public func embedContent(_ viewController: NSViewController) {
      fullContentViewController.embedChildViewController(viewController, container: contentContainer)
   }
}

extension FullContentWindowController: NSWindowDelegate {

   public func windowWillEnterFullScreen(_: Notification) {
      fullContentWindow.titleBarAccessoryViewController.isHidden = true
      titleOffsetConstraint.constant = 0
   }

   public func windowWillExitFullScreen(_: Notification) {
      fullContentWindow.titleBarAccessoryViewController.isHidden = false
      titleOffsetConstraint.constant = fullContentWindow.standardWindowButtonsRect.maxX
   }
}
