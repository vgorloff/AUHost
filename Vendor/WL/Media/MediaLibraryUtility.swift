//
//  MediaLibraryUtility.swift
//  WaveLabs
//
//  Created by User on 6/24/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

#if os(OSX)
import Foundation
import MediaLibrary

public protocol MediaLibraryUtilityDelegate: class {
   func handleEvent(_: MediaLibraryUtility.Event)
}

public final class MediaLibraryUtility: NSObject {

	public enum Event {
		case mediaSourceChanged([String : MLMediaSource]?)
	}

	private let mediaLibrary: MLMediaLibrary
	private var mediaLibraryLoadCallback: (() -> Void)?
	private var mediaLibraryIsLoaded = false
   var observation: NSKeyValueObservation?

	public weak var delegate: MediaLibraryUtilityDelegate?

	public override init() {
      mediaLibrary = MLMediaLibrary(options: [MLMediaLoadSourceTypesKey: MLMediaSourceType.audio.rawValue])
		super.init()
		Logger.initialize(subsystem: .media)
      observation = mediaLibrary.observe(\.mediaSources) { [weak self] object, _ in guard let this = self else { return }
         let sources = object.mediaSources ?? [:]
         Logger.debug(subsystem: .media, category: .handle,
                      message: "Found \(sources.count) media sources: \(Array(sources.keys))")
         for mediaSource in sources.values {
            _ = mediaSource.rootMediaGroup // Triggering lazy initialization
            // TODO: It is better to setup another KVO roundtrip. By Vlad Gorlov, Jan 15, 2016.
         }
         this.mediaLibraryIsLoaded = true
         this.delegate?.handleEvent(.mediaSourceChanged(sources))
         this.mediaLibraryLoadCallback?()
      }
	}

	deinit {
      observation = nil
		Logger.deinitialize(subsystem: .media)
	}

	public func loadMediaLibrary(completion: VoidCompletion?) {
		if mediaLibraryIsLoaded {
         completion?()
		} else {
			mediaLibraryLoadCallback = completion
			_ = mediaLibrary.mediaSources // Triggering lazy initialization
		}
	}

	public func mediaObjectsFromPlist(pasteboardPlist: NSDictionary) -> [String: [String : MLMediaObject]] {
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
#endif
