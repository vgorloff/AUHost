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

	public enum MediaLibraryChangeEvent {
		case mediaSourceChanged([String : MLMediaSource]?)
	}

	private lazy var _mediaLibrary: MLMediaLibrary = self.setUpMediaLibrary()
	private var kvoObserverOfMediaSources: KVOHelper<[String : MLMediaSource]>?
	private var mediaLibraryLoadCallback: ((Void) -> Void)?
	private var mediaLibraryIsLoaded = false

	public var onMediaLibraryChange: ((MediaLibraryChangeEvent) -> Void)?

	public override init() {
		super.init()
		Logger.initialize(subsystem: .media)
		kvoObserverOfMediaSources = KVOHelper(object: _mediaLibrary, keyPath: "mediaSources") { [weak self] result in
			guard let s = self else { return }
			if let value = result.valueNew {
            Logger.debug(subsystem: .media, category: .handle,
                         message: "Found \(value.count) media sources: \(Array(value.keys))")
				for mediaSource in value.values {
					_ = mediaSource.rootMediaGroup // Triggering lazy initialization
					// TODO: It is better to setup another KVO roundtrip. By Vlad Gorlov, Jan 15, 2016.
				}
			}
			s.mediaLibraryIsLoaded = true
			s.onMediaLibraryChange?(.mediaSourceChanged(result.valueNew))
			s.mediaLibraryLoadCallback?()
		}
	}

	deinit {
		kvoObserverOfMediaSources = nil
		Logger.deinitialize(subsystem: .media)
	}

	public func loadMediaLibrary(completion: ((Void) -> Void)?) {
		if mediaLibraryIsLoaded {
			completion?()
		} else {
			mediaLibraryLoadCallback = completion
			_ = _mediaLibrary.mediaSources // Triggering lazy initialization
		}
	}

	public func mediaObjectsFromPlist(pasteboardPlist: NSDictionary) -> [String: [String : MLMediaObject]] {
		var results = [String: [String: MLMediaObject]]()
		guard let keys = pasteboardPlist.allKeys as? [String], let mediaSources = _mediaLibrary.mediaSources else {
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

	// MARK: - Private

	private func setUpMediaLibrary() -> MLMediaLibrary {
		let o = [MLMediaLoadSourceTypesKey: MLMediaSourceType.audio.rawValue]
		return MLMediaLibrary(options: o)
	}

}
