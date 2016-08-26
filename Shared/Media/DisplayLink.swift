//
//  DisplayLink.swift
//  WaveLabs
//
//  Created by User on 6/29/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import QuartzCore
import CoreVideo

public final class DisplayLink {

   public enum Errors: Error {
      case CVReturnError(CVReturn)
   }
   private let displayLink: CVDisplayLink

   public var isRunning: Bool {
      return CVDisplayLinkIsRunning(displayLink)
   }

   init(displayLink: CVDisplayLink) {
      self.displayLink = displayLink
   }

   public static func createWithActiveCGDisplays() throws -> DisplayLink {
      var displayLink: CVDisplayLink?
      var status: CVReturn
      status = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
      try verifyStatusCode(status)
      guard let displayLinkInstance = displayLink else {
         throw Errors.CVReturnError(kCVReturnError)
      }
      return DisplayLink(displayLink: displayLinkInstance)
   }

   public func setCurrentCGDisplay(displayID: CGDirectDisplayID) throws {
      try verifyStatusCode(CVDisplayLinkSetCurrentCGDisplay(displayLink, displayID))
   }

   public func setOutputCallback(_ callback: CoreVideo.CVDisplayLinkOutputHandler) throws {
      try verifyStatusCode(CVDisplayLinkSetOutputHandler(displayLink, callback))
   }

   public func stop() throws {
      try verifyStatusCode(CVDisplayLinkStop(displayLink))
   }

   public func start() throws {
      try verifyStatusCode(CVDisplayLinkStart(displayLink))
   }

   // MARK: Private

   private func verifyStatusCode(_ statusCode: CVReturn) throws {
      if statusCode != kCVReturnSuccess {
         throw Errors.CVReturnError(statusCode)
      }
   }

   private static func verifyStatusCode(_ statusCode: CVReturn) throws {
      if statusCode != kCVReturnSuccess {
         throw Errors.CVReturnError(statusCode)
      }
   }
}

// MARK:

extension DisplayLink {

   /// Method `stop()` will be called in `deinit` automatically if `CVDisplayLink` is running.
   public final class GenericRenderer: CustomReflectable {

      private var displayLink: DisplayLink
      private let frameRateDivider: UInt
      private var frameCounter: UInt
      private var dispatchSource: SmartDispatchSourceUserDataAdd

      public var renderCallback: ((Void) -> Void)?
      private lazy var log: Logger = Logger(sender: self, context: .Media)

      // MARK: Init / Deinit

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
         log.initialize()
      }

      deinit {
         if displayLink.isRunning {
            _ = try? stop()
         }
         log.deinitialize()
      }

      public var customMirror: Mirror {
         let children = DictionaryLiteral<String, Any>(dictionaryLiteral:
            ("displayLink", displayLink), ("frameRateDivider", frameRateDivider), ("frameCounter", frameCounter))
         return Mirror(self, children: children)
      }

      // MARK: Public

      public func start(shouldResetFrameCounter: Bool = false) throws {
         log.verbose("Starting")
         if shouldResetFrameCounter {
            frameCounter = 0
         }
         dispatchSource.resume()
         try displayLink.start()
      }

      public func stop() throws {
         log.verbose("Stopping")
         dispatchSource.suspend()
         try displayLink.stop()
      }


      // MARK: Private

      private func setUpDisplayLink() throws {
         try displayLink.setOutputCallback { [weak self] _ in
            self?.dispatchSource.mergeData(value: 1)
            return kCVReturnSuccess
         }
         let displayID = CGMainDisplayID()
         try displayLink.setCurrentCGDisplay(displayID: displayID)
      }

   }

}
