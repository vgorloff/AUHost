//
//  CVDisplayLinkHelper.swift
//  WaveLabs
//
//  Created by User on 6/29/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import QuartzCore
import CoreVideo

private func AWLCVDisplayLinkHelperCallback(_:CVDisplayLink, _:UnsafePointer<CVTimeStamp>,
	_:UnsafePointer<CVTimeStamp>, _:CVOptionFlags, _:UnsafeMutablePointer<CVOptionFlags>, context: UnsafeMutablePointer<Void>)
	-> CVReturn {
		let dispatchSource = unsafeBitCast(context, dispatch_source_t.self)
		dispatch_source_merge_data(dispatchSource, 1)
		return kCVReturnSuccess
}

/// Method `stop()` will be called in `deinit` automatically if `CVDisplayLink` is running.
public final class CVDisplayLinkHelper {

	public enum Error: ErrorType {
		case CVReturnError(CVReturn)
	}

	private var displayLink: CVDisplayLink!
	private var dispatchSource: dispatch_source_t
	private let frameRateDevider: UInt
	private var frameCounter: UInt

	public var displayLinkCallback: (Void -> Void)?
	private lazy var log: Logger = {return Logger(sender: self, context: .Media)}()

	// MARK: -

	public init(frameRateDevider devider: UInt = 1) throws {
		frameRateDevider = devider
		frameCounter = devider // Force immediate draw.
		dispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue())
		dispatch_source_set_event_handler(dispatchSource) { [weak self] in guard let s = self else { return }
			s.frameCounter++
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
			stop()
		}
		log.logDeinit()
	}

	// MARK: - Public

	public func start(resetFrameCounter: Bool = false) -> CVReturn {
		log.logVerbose("Starting")
		if resetFrameCounter {
			frameCounter = 0
		}
		dispatch_resume(dispatchSource)
		return CVDisplayLinkStart(displayLink)
	}

	public func stop() -> CVReturn {
		log.logVerbose("Stopping")
		dispatch_source_cancel(dispatchSource)
		return CVDisplayLinkStop(displayLink)
	}


	// MARK: - Private

	private func setUpDisplayLink() throws -> CVDisplayLink {
		var displayLink: CVDisplayLink?

		var status = kCVReturnSuccess
		status = CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)
		if status != kCVReturnSuccess {
			throw Error.CVReturnError(status)
		}

		guard let dl = displayLink else {
			throw Error.CVReturnError(kCVReturnError)
		}

		let context = UnsafeMutablePointer<Void>(unsafeAddressOf(dispatchSource))
		status = CVDisplayLinkSetOutputCallback(dl, AWLCVDisplayLinkHelperCallback, context)
		if status != kCVReturnSuccess {
			throw Error.CVReturnError(status)
		}

		let displayID = CGMainDisplayID()
		status = CVDisplayLinkSetCurrentCGDisplay(dl, displayID)
		if status != kCVReturnSuccess {
			throw Error.CVReturnError(status)
		}

		return dl
	}

}
