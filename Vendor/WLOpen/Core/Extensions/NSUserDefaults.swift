//
//  NSUserDefaults.swift
//  WLCore
//
//  Created by Vlad Gorlov on 09.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

public extension NSUserDefaults {

	public func setDateValue(value: NSDate?, forKey key: String) {
		if let v = value {
			setObject(v, forKey: key)
		} else {
			removeObjectForKey(key)
		}
	}

	public func setStringValue(value: String?, forKey key: String) {
		if let v = value {
			setObject(v, forKey: key)
		} else {
			removeObjectForKey(key)
		}
	}

	public func setBoolValue(value: Bool?, forKey key: String) {
		if let v = value {
			setBool(v, forKey: key)
		} else {
			removeObjectForKey(key)
		}
	}

	public func setIntegerValue(value: Int?, forKey key: String) {
		if let v = value {
			setInteger(v, forKey: key)
		} else {
			removeObjectForKey(key)
		}
	}

	public func boolValueForKey(key: String) -> Bool? {
		if let _ = objectForKey(key) {
			return boolForKey(key)
		} else {
			return nil
		}
	}

	public func integerValueForKey(key: String) -> Int? {
		if let _ = objectForKey(key) {
			return integerForKey(key)
		} else {
			return nil
		}
	}

	public func dateValueForKey(key: String) -> NSDate? {
		return objectForKey(key) as? NSDate
	}

	public func stringValueForKey(key: String) -> String? {
		return stringForKey(key)
	}
}
