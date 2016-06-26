//
//  NSFileManager.swift
//  WLCore
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public enum NSFileManagerErrors: ErrorType {
	case DirectoryIsNotAvailable(String)
	case RegularFileIsNotAvailable(String)
	case CanNotOpenFileAtPath(String)
	case ExecutableNotFound(String)
}

public extension NSFileManager {

	public class var applicationDocumentsDirectory: NSURL {
		let urls = defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
		return urls[urls.count-1]
	}

	public func directoryExistsAtPath(path: String) -> Bool {
		let isDir = UnsafeMutablePointer<ObjCBool>.alloc(1)
		let isExists = fileExistsAtPath(path, isDirectory: isDir)
		return isExists && isDir.memory.boolValue
	}

	public func regularFileExistsAtPath(path: String) -> Bool {
		let isDir = UnsafeMutablePointer<ObjCBool>.alloc(1)
		let isExists = fileExistsAtPath(path, isDirectory: isDir)
		return isExists && !isDir.memory.boolValue
	}

}
