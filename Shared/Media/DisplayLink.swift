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
private func AWLCVDisplayLinkHelperCallback(_: CVDisplayLink,
                                            _: UnsafePointer<CVTimeStamp>,
                                            _: UnsafePointer<CVTimeStamp>,
                                            _: CVOptionFlags,
                                            _: UnsafeMutablePointer<CVOptionFlags>,
                                            _ context: UnsafeMutablePointer<Void>?) -> CVReturn {
	let dispatchSource = unsafeBitCast(context, to: SmartDispatchSourceUserDataAdd.self)
	dispatchSource.mergeData(value: 1)
	return kCVReturnSuccess
}

public final class DisplayLink {

   public enum Error: ErrorProtocol {
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
         throw Error.CVReturnError(kCVReturnError)
      }
		return DisplayLink(displayLink: displayLinkInstance)
   }

   public func setCurrentCGDisplay(displayID: CGDirectDisplayID) throws {
   	try verifyStatusCode(CVDisplayLinkSetCurrentCGDisplay(displayLink, displayID))
   }

   public func setOutputCallback(_ callback: CoreVideo.CVDisplayLinkOutputCallback?,
                                 userInfo: UnsafeMutablePointer<Swift.Void>?) throws {
      try verifyStatusCode(CVDisplayLinkSetOutputCallback(displayLink, callback, userInfo))
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
         throw Error.CVReturnError(statusCode)
      }
   }

   private static func verifyStatusCode(_ statusCode: CVReturn) throws {
      if statusCode != kCVReturnSuccess {
         throw Error.CVReturnError(statusCode)
      }
   }
}

// MARK:

/// Method `stop()` will be called in `deinit` automatically if `CVDisplayLink` is running.
public final class DisplayLinkRenderer: CustomReflectable {

	private var displayLink: DisplayLink
	private let frameRateDivider: UInt
	private var frameCounter: UInt
	private var dispatchSource: SmartDispatchSourceUserDataAdd

	public var renderCallback: ((Void) -> Void)?
	private lazy var log: Logger = { return Logger(sender: self, context: .Media) }()

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
		log.logInit()
	}

	deinit {
		if displayLink.isRunning {
			_ = try? stop()
		}
		log.logDeinit()
	}

	public var customMirror: Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral:
			("displayLink", displayLink), ("frameRateDivider", frameRateDivider), ("frameCounter", frameCounter))
		return Mirror(self, children: children)
	}

	// MARK: Public

	public func start(shouldResetFrameCounter: Bool = false) throws {
		log.logVerbose("Starting")
		if shouldResetFrameCounter {
			frameCounter = 0
		}
		dispatchSource.resume()
		try displayLink.start()
	}

	public func stop() throws {
		log.logVerbose("Stopping")
		dispatchSource.suspend()
		try displayLink.stop()
	}


	// MARK: Private

	private func setUpDisplayLink() throws {
      let context = UnsafeMutablePointer<Void>(unsafeAddress(of: dispatchSource))
      try displayLink.setOutputCallback(AWLCVDisplayLinkHelperCallback, userInfo: context)
      let displayID = CGMainDisplayID()
      try displayLink.setCurrentCGDisplay(displayID: displayID)
	}

}
