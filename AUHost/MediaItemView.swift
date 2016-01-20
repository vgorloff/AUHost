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

	public enum PasteboardObjectType {
		case MediaObjects(NSDictionary)
		case FilePaths([String])
	}
	private let mediaLibraryPasteboardType = "com.apple.MediaLibrary.PBoardType.MediaObjectIdentifiersPlist"
	private var isHighlighted = false {
		didSet {
			needsDisplay = true
		}
	}
	private let textDragAndDropMessage: NSString = "Drop media file here..."
	private let textDragAndDropColor = NSColor.grayColor()
	private let textDragAndDropFont = NSFont.labelFontOfSize(17)

	public var onCompleteDragWithObjects: (PasteboardObjectType -> Void)?

	required public init?(coder: NSCoder) {
		super.init(coder: coder)
		registerForDraggedTypes([mediaLibraryPasteboardType, NSFilenamesPboardType])
	}

	public override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)
		registerForDraggedTypes([mediaLibraryPasteboardType, NSFilenamesPboardType])
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
		guard let pasteboardTypes = sender.draggingPasteboard().types else {
			isHighlighted = false
			return NSDragOperation.None
		}

		if pasteboardTypes.contains(mediaLibraryPasteboardType) {
			isHighlighted = true
			return NSDragOperation.Every
		} else if pasteboardTypes.contains(NSFilenamesPboardType),
			let filePaths = sender.draggingPasteboard().propertyListForType(NSFilenamesPboardType) as? [String] {
				let acceptedFilePaths = filteredFilePaths(filePaths)
				if acceptedFilePaths.count > 0 {
					isHighlighted = true
					return NSDragOperation.Every
				} else {
					isHighlighted = false
					return NSDragOperation.None
				}
		} else {
			isHighlighted = false
			return NSDragOperation.None
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
		guard let pasteboardTypes = sender.draggingPasteboard().types else {
			isHighlighted = false
			return false
		}

		if pasteboardTypes.contains(mediaLibraryPasteboardType),
			let dict = sender.draggingPasteboard().propertyListForType(mediaLibraryPasteboardType) as? NSDictionary {
				Dispatch.Async.Main { [weak self] in
					self?.onCompleteDragWithObjects?(.MediaObjects(dict))
				}
				return true
		} else if pasteboardTypes.contains(NSFilenamesPboardType),
			let filePaths = sender.draggingPasteboard().propertyListForType(NSFilenamesPboardType) as? [String] {
				let acceptedFilePaths = filteredFilePaths(filePaths)
				Dispatch.Async.Main { [weak self] in
					self?.onCompleteDragWithObjects?(.FilePaths(acceptedFilePaths))
				}
				return true
		} else {
			isHighlighted = false
			return false
		}
	}

	public override func concludeDragOperation(sender: NSDraggingInfo?) {
		isHighlighted = false
	}

	// MARK: - Private

	private func filteredFilePaths(pasteboardFilePaths: [String]) -> [String] {
		let ws = NSWorkspace.sharedWorkspace()
		let result = pasteboardFilePaths.filter { element in
			if let fileType = trythrow({try ws.typeOfFile(element)}) {
				return UTTypeConformsTo(fileType, kUTTypeAudio)
			}
			return false
		}
		return result
	}

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
