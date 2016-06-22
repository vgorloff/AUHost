//
//  MediaObjectPasteboardUtility.swift
//  WLMedia
//
//  Created by Vlad Gorlov on 26.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit

public struct MediaObjectPasteboardUtility {

	public enum PasteboardObjects {
		case MediaObjects(NSDictionary)
		case FilePaths([String])
		case None
	}

	private let mediaLibraryPasteboardType = "com.apple.MediaLibrary.PBoardType.MediaObjectIdentifiersPlist"
	public let draggedTypes: [String]

	public init() {
		draggedTypes = [mediaLibraryPasteboardType, NSFilenamesPboardType]
	}

	public func objectsFromPasteboard(pasteboard: NSPasteboard) -> PasteboardObjects {
		guard let pasteboardTypes = pasteboard.types else {
			return .None
		}
		if pasteboardTypes.contains(mediaLibraryPasteboardType),
			let dict = pasteboard.propertyListForType(mediaLibraryPasteboardType) as? NSDictionary {
				return .MediaObjects(dict)
		} else if pasteboardTypes.contains(NSFilenamesPboardType),
			let filePaths = pasteboard.propertyListForType(NSFilenamesPboardType) as? [String] {
				let acceptedFilePaths = filteredFilePaths(filePaths)
				return acceptedFilePaths.count > 0 ? .FilePaths(acceptedFilePaths) : .None
		} else {
			return .None
		}
	}

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
}
