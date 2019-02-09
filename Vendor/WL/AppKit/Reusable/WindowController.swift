//
//  WindowController.swift
//  mcVendor
//
//  Created by Vlad Gorlov on 16.07.18.
//

import AppKit

open class WindowController: NSWindowController {

   public let contentWindow: Window
   public let viewController: NSViewController

   public convenience init(viewController: NSViewController, windowSize: CGSize = CGSize(width: 800, height: 600)) {
      let window = Window(contentRect: CGRect(origin: CGPoint(), size: windowSize), style: .default)
      self.init(window: window, viewController: viewController)
   }

   public init(window: Window, viewController: NSViewController) {
      contentWindow = window
      self.viewController = viewController
      super.init(window: window)
      let frameSize = contentWindow.contentRect(forFrameRect: contentWindow.frame).size
      viewController.view.setFrameSize(frameSize)
      contentWindow.contentViewController = viewController
      if let screenSize = window.screen?.visibleFrame.size {
         let origin = NSPoint(x: (screenSize.width - frameSize.width) / 2,
                              y: (screenSize.height - frameSize.height) / 2)

         contentWindow.setFrameOrigin(origin)
      }

      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
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
