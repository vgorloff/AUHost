//
//  NSCache.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#endif

private final class CacheValueWrapper<T> {
	let value: T
	init(_ aValue: T) {
		value = aValue
	}
}

public extension NSCache {
	subscript(key: AnyObject) -> AnyObject? {
		get {
			return objectForKey(key)
		}
		set {
			if let value: AnyObject = newValue {
				setObject(value, forKey: key)
			} else {
				removeObjectForKey(key)
			}
		}
	}
	public func setFloat(value: Float, forKey: AnyObject) {
		setObject(value, forKey: forKey)
	}
	public func floatForKey(forKey: AnyObject) -> Float? {
		return objectForKey(forKey) as? Float
	}
	public func setData(value: NSData, forKey: AnyObject) {
		setObject(value, forKey: forKey)
	}
	public func dataForKey(forKey: AnyObject) -> NSData? {
		return objectForKey(forKey) as? NSData
	}
	public func setObjectValue<T>(value: T, forKey key: AnyObject) {
		if let objectValue = value as? AnyObject {
			setObject(objectValue, forKey: key)
		} else {
			setObject(CacheValueWrapper(value), forKey: key)
		}
	}
	public func objectValueForKey<T>(key: AnyObject) -> T? {
		if let warpper = objectForKey(key) as? CacheValueWrapper<T> {
			return warpper.value
		} else if let value = objectForKey(key) as? T {
			return value
		} else {
			return nil
		}
	}

	public func objectForKey<T: AnyObject>(forKey: AnyObject, @noescape fallback: Void -> T?) -> T? {
		if let cachedObject = objectForKey(forKey) as? T {
			return cachedObject
		}
		if let newImage = fallback() {
			setObject(newImage, forKey: forKey)
			return newImage
		}
		return nil
	}

	#if os(iOS)
	public func setImage(value: UIImage, forKey: AnyObject) {
		setObject(value, forKey: forKey)
	}

	public func imageForKey(forKey: AnyObject) -> UIImage? {
		return objectForKey(forKey) as? UIImage
	}
	#endif
}
