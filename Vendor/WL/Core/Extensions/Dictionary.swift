//
//  Dictionary.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 12.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public enum DictionaryError: ErrorType {
	case MissedRequiredKey(String)
}

public extension Dictionary {

	public func valueForRequiredKey<T>(key: Key) throws -> T {
		guard let unwrappedValue = self[key], let value = unwrappedValue as? T else {
			throw DictionaryError.MissedRequiredKey(String(key))
		}
		return value
	}

	public func valueForKey<T>(key: Key) -> T? {
		if let unwrappedValue = self[key], let value = unwrappedValue as? T {
			return value
		}
		return nil
	}

	public func hasKey(key: Key) -> Bool {
		return Array(keys).filter { $0 == key }.count == 1
	}

}
