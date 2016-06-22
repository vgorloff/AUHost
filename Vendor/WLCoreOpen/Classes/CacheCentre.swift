//
//  CacheCentre.swift
//  WLCore
//
//  Created by Vlad Gorlov on 06.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

public final class CacheCentre {

	private let registeredCachesLock: NonRecursiveLocking = SpinLock()
	private var registeredCaches = Dictionary<String, NSCache>()
	private static let instance = CacheCentre()

	public static func cacheForClass(cls: AnyClass) -> NSCache {
		let cacheID = "\(StringFromClass(CacheCentre)):\(StringFromClass(cls))"
		return CacheCentre.cacheForIdentifier(cacheID)
	}
	public static func cacheForIdentifier(cacheID: String) -> NSCache {
		let result: NSCache = instance.registeredCachesLock.synchronized {
			if let existedCache = instance.registeredCaches[cacheID] {
				return existedCache
			} else {
				let newCache = NSCache()
				newCache.name = cacheID
				instance.registeredCaches[cacheID] = newCache
				return newCache
			}
		}
		return result
	}
}
