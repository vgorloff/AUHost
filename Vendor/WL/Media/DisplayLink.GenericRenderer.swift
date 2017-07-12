//
//  DisplayLink.GenericRenderer.swift
//  WaveLabs
//
//  Created by VG (DE) on 23.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

#if os(OSX)
import Foundation

extension DisplayLink {

   /// Method `stop()` will be called in `deinit` automatically if `CVDisplayLink` is running.
   public final class GenericRenderer {

      private var displayLink: DisplayLink
      private let frameRateDivider: UInt
      private var frameCounter: UInt
      private var dispatchSource: SmartDispatchSourceUserDataAdd

      public var renderCallback: VoidCompletion?

      public init(frameRateDivider divider: UInt = 1, renderCallbackQueue: DispatchQueue? = nil) throws {
         frameRateDivider = divider
         frameCounter = divider // Force immediate draw.
         displayLink = try DisplayLink.createWithActiveCGDisplays()
         dispatchSource = SmartDispatchSourceUserDataAdd(queue: renderCallbackQueue)
         try setUpDisplayLink()
         dispatchSource.setEventHandler { [weak self] in guard let s = self else { return }
            s.frameCounter += 1
            if s.frameCounter >= s.frameRateDivider {
               s.renderCallback?()
               s.frameCounter = 0
            }
         }
         Log.initialize(subsystem: .media)
      }

      deinit {
         if displayLink.isRunning {
            _ = try? stop()
         }
         Log.deinitialize(subsystem: .media)
      }
   }
}

extension DisplayLink.GenericRenderer {

   public func start(shouldResetFrameCounter: Bool = false) throws {
      Log.debug(subsystem: .media, category: .event, message: "Starting")
      if shouldResetFrameCounter {
         frameCounter = 0
      }
      dispatchSource.resume()
      try displayLink.start()
   }

   public func stop() throws {
      Log.debug(subsystem: .media, category: .event, message: "Stopping")
      dispatchSource.suspend()
      try displayLink.stop()
   }

   // MARK: Private
   private func setUpDisplayLink() throws {
      let context = Unmanaged.passUnretained(dispatchSource).toOpaque()
      try displayLink.setOutputCallback(AWLCVDisplayLinkHelperCallback, userInfo: context)
      let displayID = CGMainDisplayID()
      try displayLink.setCurrentCGDisplay(displayID: displayID)
   }

}

extension DisplayLink.GenericRenderer: CustomReflectable {

   public var customMirror: Mirror {
      let children = DictionaryLiteral<String, Any>(dictionaryLiteral:
         ("displayLink", displayLink), ("frameRateDivider", frameRateDivider), ("frameCounter", frameCounter))
      return Mirror(self, children: children)
   }
}
#endif
