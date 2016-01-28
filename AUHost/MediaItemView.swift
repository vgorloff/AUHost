//
//  MediaItemView.swift
//  AudioUnitExtensionDemo
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import AVFoundation
import WLShared
import Accelerate

public final class MediaItemView: NSView {
	private var isHighlighted = false {
		didSet {
			needsDisplay = true
		}
	}
	private let textDragAndDropMessage: NSString = "Drop media file here..."
	private var textDragAndDropColor = AlternativeValue<NSColor>(NSColor.grayColor(), altValue: NSColor.whiteColor())
	private let textDragAndDropFont = NSFont.labelFontOfSize(17)
	private let waveformColor = NSColor(hexString: "#51A2F3") ?? NSColor.redColor()
	private let pbUtil = MediaObjectPasteboardUtility()
	private lazy var wfCache = WaveformCacheUtility()
	private lazy var wfDrawingProvider = WaveformDrawingDataProvider(dataType: .CGPoint)
	var mediaFileURL: NSURL? {
		didSet {
			rebuildWaveform()
		}
	}
	public override var frame: NSRect {
		didSet {
			rebuildWaveform()
		}
	}

	public var onCompleteDragWithObjects: (MediaObjectPasteboardUtility.PasteboardObjects -> Void)?

	// MARK: -

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		registerForDraggedTypes(pbUtil.draggedTypes)
	}

	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		registerForDraggedTypes(pbUtil.draggedTypes)
	}

	deinit {
		unregisterDraggedTypes()
	}

	public override func drawRect(dirtyRect: NSRect) {
		NSColor.whiteColor().setFill()
		NSRectFill(dirtyRect)
		(isHighlighted ? NSColor.keyboardFocusIndicatorColor() : NSColor.gridColor()).setStroke()
		let borderWidth = isHighlighted ? 2.CGFloatValue : 1.CGFloatValue
		NSBezierPath.setDefaultLineWidth(borderWidth)
		NSBezierPath.strokeRect(bounds.insetBy(dx: 0.5 * borderWidth, dy: 0.5 * borderWidth))

		textDragAndDropColor.useAltValue = cachedWaveform() != nil
		drawWaveform()
		drawTextMessage()
	}

	// MARK: - NSDraggingDestination

	public override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
		let result = pbUtil.objectsFromPasteboard(sender.draggingPasteboard())
		switch result {
		case .None:
			isHighlighted = false
			return NSDragOperation.None
		case .FilePaths, .MediaObjects:
			isHighlighted = true
			return NSDragOperation.Every
		}
	}

	public override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
		return NSDragOperation.Every
	}

	public override func draggingExited(sender: NSDraggingInfo?) {
		isHighlighted = false
	}

	public override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
		return true
	}

	public override func performDragOperation(sender: NSDraggingInfo) -> Bool {
		let result = pbUtil.objectsFromPasteboard(sender.draggingPasteboard())
		switch result {
		case .None:
			isHighlighted = false
			return false
		case .MediaObjects(let dict):
			Dispatch.Async.Main { [weak self] in
				self?.onCompleteDragWithObjects?(.MediaObjects(dict))
			}
			return true
		case .FilePaths(let acceptedFilePaths):
			Dispatch.Async.Main { [weak self] in
				self?.onCompleteDragWithObjects?(.FilePaths(acceptedFilePaths))
			}
			return true
		}
	}

	public override func concludeDragOperation(sender: NSDraggingInfo?) {
		isHighlighted = false
	}

	// MARK: - Private

	private func getScaleFactor() -> CGFloat {
		let backingSize = convertSizeToBacking(bounds.size)
		return backingSize.width / bounds.size.width
	}

	private func drawWaveform() {

		// !inLiveResize,
		guard !inLiveResize, let context = NSGraphicsContext.currentContext()?.CGContext, let waveform = cachedWaveform() else {
			return // FIXME: Implement interpolation for live resize and while waiting for waveform cashe arrival. By Vlad Gorlov, Jan 27, 2016.
		}
		let scaleFactor = getScaleFactor()
		let lineWidth = 1 / scaleFactor

		assert(Int(bounds.width * scaleFactor) == waveform.count)
		wfDrawingProvider.reset(xOffset: 0.5 * lineWidth, yOffset: 0.5 * lineWidth, width: bounds.width - lineWidth,
			height: bounds.height - lineWidth)
		for index in 0..<waveform.count {
			let waveformValue = waveform[index]
			wfDrawingProvider.addVerticalLineAtXPosition(index.CGFloatValue / scaleFactor, valueMin: waveformValue.min.CGFloatValue,
				valueMax: waveformValue.max.CGFloatValue)
		}
		CGContextSetShouldAntialias(context, false);
//		CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor)
		CGContextTranslateCTM(context, 0.5 / scaleFactor, 0.5 / scaleFactor); // Center the origin at center of a pixel

		CGContextSaveGState(context)
//		CGContextFillRect(context, bounds)
		CGContextSetStrokeColorWithColor(context, waveformColor.CGColor)
		CGContextSetLineWidth(context, lineWidth);
		CGContextStrokeLineSegments(context, wfDrawingProvider.points, wfDrawingProvider.numberOfPoints)
		CGContextRestoreGState(context)
	}

	private func drawTextMessage() {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = NSTextAlignment.Center
		let attributes = [NSParagraphStyleAttributeName: paragraphStyle,
			NSForegroundColorAttributeName: textDragAndDropColor.currentValue,
			NSFontAttributeName: textDragAndDropFont]
		let textSize = textDragAndDropMessage.sizeWithAttributes(attributes)
		let offsetX = bounds.height - textSize.height
		textDragAndDropMessage.drawInRect(bounds.insetBy(dx: 8, dy: offsetX * 0.5), withAttributes: attributes)
	}

	private func rebuildWaveform() {
		guard let mf = mediaFileURL else {
			return
		}
		wfCache.buildWaveformForResolution(fileURL: mf, resolution: UInt64(bounds.width * getScaleFactor())) { [weak self] result in
			switch result {
			case .Failure(let e):
				Swift.print(e)
			case .Success(_):
				Dispatch.Async.Main { [weak self] in
					self?.needsDisplay = true
				}
			}
		}
	}

	private func cachedWaveform() -> [MinMax<Float>]? {
		guard let mf = mediaFileURL else {
			return nil
		}
		return wfCache.cachedWaveformForResolution(mf, resolution: UInt64(bounds.width * getScaleFactor()))
	}

}
