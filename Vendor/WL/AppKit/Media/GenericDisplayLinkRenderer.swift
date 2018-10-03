//
//  GenericDisplayLinkRenderer.swift
//  WaveLabs
//
//  Created by VG (DE) on 23.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import CoreVideo
import Foundation

// swiftlint:disable:next function_parameter_count
func GenericDisplayLinkRendererCallback(_: CVDisplayLink,
                                        _: UnsafePointer<CVTimeStamp>,
                                        _: UnsafePointer<CVTimeStamp>,
                                        _: CVOptionFlags,
                                        _: UnsafeMutablePointer<CVOptionFlags>,
                                        _ context: UnsafeMutableRawPointer?) -> CVReturn {
   let this = unsafeBitCast(context, to: GenericDisplayLinkRenderer.self)
   this.handleCallback()
   return kCVReturnSuccess
}

/// Method `stop()` will be called in `deinit` automatically if `CVDisplayLink` is running.
public class GenericDisplayLinkRenderer {

   public let displayLink: DisplayLink
   public var frameRateDivider: UInt = 1
   private var frameCounter: UInt

   public typealias RenderCallback = () -> Void
   private var callback: RenderCallback?

   public init(frameRateDivider divider: UInt = 1, callback: RenderCallback? = nil) throws {
      frameRateDivider = divider
      frameCounter = divider // To force immediate draw.
      displayLink = try DisplayLink.createWithActiveCGDisplays()
      setCallback(callback)
      try setupInstance()
      log.initialize()
   }

   deinit {
      if displayLink.isRunning {
         _ = try? stop()
      }
      log.deinitialize()
   }

   public func start(shouldResetFrameCounter: Bool = false) throws {
      guard !displayLink.isRunning else {
         return
      }
      log.debug(.media, "Starting")
      if shouldResetFrameCounter {
         frameCounter = 0
      }
      try displayLink.start()
   }

   public func stop() throws {
      guard displayLink.isRunning else {
         return
      }
      log.debug(.media, "Stopping")
      try displayLink.stop()
   }

   public func setCallback(_ callback: RenderCallback?) {
      self.callback = callback
   }
}

extension GenericDisplayLinkRenderer {

   public var isRunning: Bool {
      return displayLink.isRunning
   }
}

extension GenericDisplayLinkRenderer {

   private func setupInstance() throws {
      let displayID = CGMainDisplayID()
      try displayLink.setCurrentCGDisplay(displayID: displayID)
      let context = Unmanaged.passUnretained(self).toOpaque()
      try displayLink.setOutputCallback(GenericDisplayLinkRendererCallback, userInfo: context)
   }

   fileprivate func handleCallback() {
      frameCounter += 1
      if frameCounter >= frameRateDivider {
         callback?()
         frameCounter = 0
      }
   }
}

extension GenericDisplayLinkRenderer: CustomReflectable {

   public var customMirror: Mirror {
      let children: [(String?, Any)] = [("displayLink", displayLink),
                                        ("frameRateDivider", frameRateDivider),
                                        ("frameCounter", frameCounter)]
      return Mirror(self, children: children)
   }
}
