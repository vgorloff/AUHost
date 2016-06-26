//
//  NSBundle.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 30.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension NSBundle {
	public enum Errors: ErrorType {
		case MissedURLForResource(resourceName: String, resourceExtension: String)
	}
	public func URLForResource(resourceName: String, resourceExtension: String) throws -> NSURL {
		guard let url = URLForResource(resourceName, withExtension: resourceExtension) else {
			throw NSBundle.Errors.MissedURLForResource(resourceName: resourceName, resourceExtension: resourceExtension)
		}
		return url
	}
}
