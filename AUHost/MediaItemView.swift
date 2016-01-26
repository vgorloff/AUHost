//
//  MediaItemView.swift
//  AudioUnitExtensionDemo
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import WLShared

public final class MediaItemView: NSView {
	private var isHighlighted = false {
		didSet {
			needsDisplay = true
		}
	}
	private let textDragAndDropMessage: NSString = "Drop media file here..."
	private let textDragAndDropColor = NSColor.grayColor()
	private let textDragAndDropFont = NSFont.labelFontOfSize(17)
	private let pbUtil = MediaObjectPasteboardUtility()

	public var onCompleteDragWithObjects: (MediaObjectPasteboardUtility.PasteboardObjects -> Void)?

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

	private func drawTextMessage() {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = NSTextAlignment.Center
		let attributes = [NSParagraphStyleAttributeName: paragraphStyle,
			NSForegroundColorAttributeName: textDragAndDropColor,
			NSFontAttributeName: textDragAndDropFont]
		let textSize = textDragAndDropMessage.sizeWithAttributes(attributes)
		let offsetX = bounds.height - textSize.height
		textDragAndDropMessage.drawInRect(bounds.insetBy(dx: 8, dy: offsetX * 0.5), withAttributes: attributes)
	}
	
}
