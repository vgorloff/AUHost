//
//  MediaObjectPasteboardUtility.swift
//  WaveLabs
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
         let dict = pasteboard.propertyList(forType: mediaLibraryPasteboardType) as? NSDictionary {
         return .MediaObjects(dict)
      } else if pasteboardTypes.contains(NSFilenamesPboardType),
         let filePaths = pasteboard.propertyList(forType: NSFilenamesPboardType) as? [String] {
         let acceptedFilePaths = filteredFilePaths(pasteboardFilePaths: filePaths)
         return acceptedFilePaths.count > 0 ? .FilePaths(acceptedFilePaths) : .None
      } else {
         return .None
      }
   }

   private func filteredFilePaths(pasteboardFilePaths: [String]) -> [String] {
      let ws = NSWorkspace.shared()
      let result = pasteboardFilePaths.filter { element in
         let fileType: String? = g.perform ({try ws.type(ofFile: element)}) {
            print($0)
         }
         if let fileType = fileType {
            return UTTypeConformsTo(fileType as CFString, kUTTypeAudio)
         }
         return false
      }
      return result
   }
}
