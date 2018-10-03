//
//  DisplayLink.swift
//  WaveLabs
//
//  Created by User on 6/29/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import AppKit
import CoreVideo
import QuartzCore

public final class DisplayLink {

   private let displayLink: CVDisplayLink

   init(displayLink: CVDisplayLink) {
      self.displayLink = displayLink
   }
}

extension DisplayLink {

   public static func createWithActiveCGDisplays() throws -> DisplayLink {
      var displayLink: CVDisplayLink?
      if let error = CVError(code: CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)) {
         throw error
      }
      guard let displayLinkInstance = displayLink else {
         throw CVError.code(kCVReturnAllocationFailed)
      }
      return DisplayLink(displayLink: displayLinkInstance)
   }
}

extension DisplayLink {

   public var isRunning: Bool {
      return CVDisplayLinkIsRunning(displayLink)
   }

   public func stop() throws {
      guard isRunning else {
         return
      }
      if let error = CVError(code: CVDisplayLinkStop(displayLink)) {
         throw error
      }
   }

   public func start() throws {
      guard !isRunning else {
         return
      }
      if let error = CVError(code: CVDisplayLinkStart(displayLink)) {
         throw error
      }
   }

   public func setCurrentCGDisplay(displayID: CGDirectDisplayID) throws {
      if let error = CVError(code: CVDisplayLinkSetCurrentCGDisplay(displayLink, displayID)) {
         throw error
      }
   }

   public func setOutputCallback(_ callback: CoreVideo.CVDisplayLinkOutputCallback?, userInfo: UnsafeMutableRawPointer?) throws {
      if let error = CVError(code: CVDisplayLinkSetOutputCallback(displayLink, callback, userInfo)) {
         throw error
      }
   }

   public func setCurrentCGDisplayFromOpenGLContext(context: CGLContextObj, pixelFormat: CGLPixelFormatObj) throws {
      let status = CVDisplayLinkSetCurrentCGDisplayFromOpenGLContext(displayLink, context, pixelFormat)
      try throwIfNeeded(CVError(code: status))
   }

   public func setCurrentCGDisplayFromOpenGLContext(context: NSOpenGLContext, pixelFormat: NSOpenGLPixelFormat) throws {
      if let context = context.cglContextObj, let pixelFormat = pixelFormat.cglPixelFormatObj {
         try setCurrentCGDisplayFromOpenGLContext(context: context, pixelFormat: pixelFormat)
      }
   }
}
