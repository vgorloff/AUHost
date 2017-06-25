//
//  DisplayLink.swift
//  WaveLabs
//
//  Created by User on 6/29/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import QuartzCore
import CoreVideo

// swiftlint:disable:next function_parameter_count
func AWLCVDisplayLinkHelperCallback(_: CVDisplayLink,
                                    _: UnsafePointer<CVTimeStamp>,
                                    _: UnsafePointer<CVTimeStamp>,
                                    _: CVOptionFlags,
                                    _: UnsafeMutablePointer<CVOptionFlags>,
                                    _ context: UnsafeMutableRawPointer?) -> CVReturn {
   let dispatchSource = unsafeBitCast(context, to: SmartDispatchSourceUserDataAdd.self)
   dispatchSource.mergeData(value: 1)
   return kCVReturnSuccess
}

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

   public func setOutputCallback(_ callback: CoreVideo.CVDisplayLinkOutputCallback?,
                                 userInfo: UnsafeMutableRawPointer?) throws {
      try verifyStatusCode(CVDisplayLinkSetOutputCallback(displayLink, callback, userInfo))
   }

   public func stop() throws {
      try verifyStatusCode(CVDisplayLinkStop(displayLink))
   }

   public func start() throws {
      try verifyStatusCode(CVDisplayLinkStart(displayLink))
   }

}

extension DisplayLink {

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


