//
//  WindowController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.07.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

public class __WindowControllerContent: InstanceHolder<WindowController> {

   public var window: Window {
      return instance._window
   }

   public var viewController: NSViewController {
      return instance._viewController
   }
}

open class WindowController: NSWindowController {

   fileprivate let _window: Window
   fileprivate let _viewController: NSViewController

   public var content: __WindowControllerContent {
      return __WindowControllerContent(instance: self)
   }

   public init(viewController: NSViewController, windowSize: CGSize = CGSize(width: 800, height: 600)) {
      _window = Window(contentRect: CGRect(origin: CGPoint(), size: windowSize), style: .default)
      _viewController = viewController
      super.init(window: _window)
      initializeController()
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public init(viewController: NSViewController, window: Window) {
      _window = window
      _viewController = viewController
      super.init(window: window)
      initializeController()
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   private func initializeController() {
      let frameSize = _window.contentRect(forFrameRect: _window.frame).size
      _viewController.view.setFrameSize(frameSize)
      _window.contentViewController = _viewController
      if let screen = _window.screen {
         moveToCenter(of: screen)
      }
   }

   public func moveToCenter(of screen: NSScreen) {
      let frameSize = _window.contentRect(forFrameRect: _window.frame).size
      let screenSize = screen.visibleFrame.size
      let origin = NSPoint(x: (screenSize.width - frameSize.width) / 2,
                           y: (screenSize.height - frameSize.height) / 2)

      _window.setFrameOrigin(origin)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupDefaults() {
   }
}
#endif
