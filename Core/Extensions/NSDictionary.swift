/// File: NSDictionary.swift
/// Project: WLCore
/// Author: Created by Vlad Gorlov on 04.02.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import Foundation

public extension NSDictionary {
	public enum Errors: ErrorType {
		case UnableToWriteToFile(String)
		case UnableToReadFromURL(NSURL)
	}
	public func hasKey<T: AnyObject where T: Equatable>(key: T) -> Bool {
		return allKeys.filter { element in return (element as? T) == key }.count == 1
	}
	public func writePlistToFile(path: String, atomically: Bool) throws {
		if !writeToFile(path, atomically: atomically) {
			throw Errors.UnableToWriteToFile(path)
		}
	}
	public static func readPlistFromURL(plistURL: NSURL) throws -> NSDictionary {
		guard let plist = NSDictionary(contentsOfURL: plistURL) else {
			throw Errors.UnableToReadFromURL(plistURL)
		}
		return plist
	}
}
