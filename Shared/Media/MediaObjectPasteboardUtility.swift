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

   private let mediaLibraryPasteboardType
      = NSPasteboard.PasteboardType("com.apple.MediaLibrary.PBoardType.MediaObjectIdentifiersPlist")
   // FIXME: Workaround. Replace after getting answer on SO question:
   // https://stackoverflow.com/questions/44537356/swift-4-nsfilenamespboardtype-not-available-what-to-use-instead-for-registerfo
   private let fileNamesPasteboardType = NSPasteboard.PasteboardType("NSFilenamesPboardType")
   public let draggedTypes: [NSPasteboard.PasteboardType]

   public init() {
      draggedTypes = [mediaLibraryPasteboardType, fileNamesPasteboardType]
   }

   public func objectsFromPasteboard(pasteboard: NSPasteboard) -> PasteboardObjects {
      guard let pasteboardTypes = pasteboard.types else {
         return .none
      }
      if pasteboardTypes.contains(mediaLibraryPasteboardType),
         let dict = pasteboard.propertyList(forType: mediaLibraryPasteboardType) as? NSDictionary {
         return .mediaObjects(dict)
      } else if pasteboardTypes.contains(fileNamesPasteboardType),
         let filePaths = pasteboard.propertyList(forType: fileNamesPasteboardType) as? [String] {
         let acceptedFilePaths = filteredFilePaths(pasteboardFilePaths: filePaths)
         return acceptedFilePaths.count > 0 ? .filePaths(acceptedFilePaths) : .none
      } else {
         return .none
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
