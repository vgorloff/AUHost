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
      case mediaObjects(NSDictionary)
      case filePaths([String])
      case none
   }
   
   private let mediaLibraryPasteboardType = "com.apple.MediaLibrary.PBoardType.MediaObjectIdentifiersPlist"
   public let draggedTypes: [String]
   
   public init() {
      if #available(OSX 10.13, *) {
         draggedTypes = [mediaLibraryPasteboardType, NSPasteboard.PasteboardType.fileURL.rawValue]
      } else {
         fatalError("unavailable")
      }
   }
   
   
   public func objectsFromPasteboard(pasteboard: NSPasteboard) -> PasteboardObjects {
      guard let pasteboardTypes = pasteboard.types else {
         return .none
      }
      if #available(OSX 10.13, *) {
         if pasteboardTypes.contains(NSPasteboard.PasteboardType(rawValue: mediaLibraryPasteboardType)),
            let dict = pasteboard.propertyList(forType: NSPasteboard.PasteboardType(rawValue: mediaLibraryPasteboardType)) as? NSDictionary {
            return .mediaObjects(dict)
         } else if pasteboardTypes.contains(NSPasteboard.PasteboardType.fileURL),
            let filePaths = pasteboard.propertyList(forType: NSPasteboard.PasteboardType.fileURL) as? [String] {
            let acceptedFilePaths = filteredFilePaths(pasteboardFilePaths: filePaths)
            return acceptedFilePaths.count > 0 ? .filePaths(acceptedFilePaths) : .none
         } else {
            return .none
         }
      } else {
         fatalError("unavailable")
      }
   }
   
   private func filteredFilePaths(pasteboardFilePaths: [String]) -> [String] {
      let ws = NSWorkspace.shared
      let result = pasteboardFilePaths.filter { element in
         do {
            let fileType = try ws.type(ofFile: element)
            return UTTypeConformsTo(fileType as CFString, kUTTypeAudio)
         } catch {
            print("\(error)")
         }
         return false
      }
      return result
   }
}
