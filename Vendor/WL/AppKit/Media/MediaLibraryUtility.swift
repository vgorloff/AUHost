//
//  MediaLibraryUtility.swift
//  WaveLabs
//
//  Created by User on 6/24/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation
import MediaLibrary

public final class MediaLibraryUtility: NSObject {

   public enum Event {
      case mediaSourceChanged([String: MLMediaSource])
   }

   private let mediaLibrary: MLMediaLibrary
   private var mediaLibraryLoadCallback: ((Event) -> Void)?
   private var mediaLibraryIsLoaded = false
   var observation: NSKeyValueObservation?

   public var eventHandler: ((Event) -> Void)?

   public override init() {
      mediaLibrary = MLMediaLibrary(options: [MLMediaLoadSourceTypesKey: MLMediaSourceType.audio.rawValue])
      super.init()
      log.initialize()
      observation = mediaLibrary.observe(\.mediaSources) { [weak self] object, _ in guard let this = self else { return }
         let sources = object.mediaSources ?? [:]
         log.debug(.media, "Found \(sources.count) media sources: \(Array(sources.keys))")
         for mediaSource in sources.values {
            _ = mediaSource.rootMediaGroup // Triggering lazy initialization
            // TODO: It is better to setup another KVO roundtrip. By Vlad Gorlov, Jan 15, 2016.
         }
         this.mediaLibraryIsLoaded = true
         let event = Event.mediaSourceChanged(sources)
         this.eventHandler?(event)
      }
   }

   deinit {
      observation = nil
      log.deinitialize()
   }
}

extension MediaLibraryUtility {

   public func loadMediaLibrary() {
      if !mediaLibraryIsLoaded {
         _ = mediaLibrary.mediaSources // Triggering lazy initialization
      }
   }

   public func mediaObjectsFromPlist(pasteboardPlist: NSDictionary) -> [String: [String: MLMediaObject]] {
      var results = [String: [String: MLMediaObject]]()
      guard let keys = pasteboardPlist.allKeys as? [String], let mediaSources = mediaLibrary.mediaSources else {
         return results
      }
      for key in keys {
         guard let mediaSource = mediaSources[key], let mediaObjectIDs = pasteboardPlist.object(forKey: key) as? [String] else {
            continue
         }
         results[key] = mediaSource.mediaObjects(forIdentifiers: mediaObjectIDs)
      }
      return results
   }
}
