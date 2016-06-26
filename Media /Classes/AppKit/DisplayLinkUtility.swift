//
//  DisplayLinkUtility.swift
//  WLMedia
//
//  Created by User on 6/29/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import QuartzCore
import CoreVideo

// swiftlint:disable:next function_parameter_count
private func AWLCVDisplayLinkHelperCallback(_:CVDisplayLink, _:UnsafePointer<CVTimeStamp>, _:UnsafePointer<CVTimeStamp>,
	_:CVOptionFlags, _:UnsafeMutablePointer<CVOptionFlags>, context: UnsafeMutablePointer<Void>) -> CVReturn {
		let dispatchSource = unsafeBitCast(context, DispatchSourceData.self)
		dispatchSource.mergeData(1)
		return kCVReturnSuccess
}

/// Method `stop()` will be called in `deinit` automatically if `CVDisplayLink` is running.
@available(*, renamed="DisplayLinkUtility")
typealias CVDisplayLinkHelper = DisplayLinkUtility

public final class DisplayLinkUtility: CustomReflectable {

	public enum Error: ErrorType {
		case CVReturnError(CVReturn)
	}

	private var displayLink: CVDisplayLink!
	private let frameRateDevider: UInt
	private var frameCounter: UInt
	private var dispatchSource: DispatchSourceData!

	public var displayLinkCallback: (Void -> Void)?
	private lazy var log: Logger = {return Logger(sender: self, context: .Media)}()

	// MARK: -

	public init(frameRateDevider devider: UInt = 1) throws {
		frameRateDevider = devider
		frameCounter = devider // Force immediate draw.
		dispatchSource = try DispatchSourceData(type: .Add)
		dispatchSource.dispatchSourceCallback = { [weak self] in guard let s = self else { return }
			s.frameCounter += 1
			if s.frameCounter >= s.frameRateDevider {
				s.displayLinkCallback?()
				s.frameCounter = 0
			}
		}
		displayLink = try setUpDisplayLink()
		log.logInit()
	}

	deinit {
		if CVDisplayLinkIsRunning(displayLink) {
			_ = try? stop()
		}
		log.logDeinit()
	}

	public func customMirror() -> Mirror {
		let children = DictionaryLiteral<String, Any>(dictionaryLiteral:
			("displayLink", displayLink), ("frameRateDevider", frameRateDevider), ("frameCounter", frameCounter))
		return Mirror(self, children: children)
	}

	// MARK: - Public

	public func start(shouldResetFrameCounter: Bool = false) throws {
		log.logVerbose("Starting")
		if shouldResetFrameCounter {
			frameCounter = 0
		}
		dispatchSource.resume()
		try verifyStatusCode(CVDisplayLinkStart(displayLink))
	}

	public func stop() throws {
		log.logVerbose("Stopping")
		dispatchSource.suspend()
		try verifyStatusCode(CVDisplayLinkStop(displayLink))
	}


	// MARK: - Private

	private func setUpDisplayLink() throws -> CVDisplayLink {
		var displayLink: CVDisplayLink?

		var status: CVReturn
		status = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
		try verifyStatusCode(status)

		guard let dl = displayLink else {
			throw Error.CVReturnError(kCVReturnError)
		}

		let context = UnsafeMutablePointer<Void>(unsafeAddressOf(dispatchSource))
		status = CVDisplayLinkSetOutputCallback(dl, AWLCVDisplayLinkHelperCallback, context)
		try verifyStatusCode(status)

		let displayID = CGMainDisplayID()
		status = CVDisplayLinkSetCurrentCGDisplay(dl, displayID)
		try verifyStatusCode(status)

		return dl
	}

	private func verifyStatusCode(statusCode: CVReturn) throws {
		if statusCode != kCVReturnSuccess {
			throw Error.CVReturnError(statusCode)
		}
	}

}
