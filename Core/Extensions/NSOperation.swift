//
//  NSOperation.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 25.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

private struct _NSOperationAssociatedKeys {
	static var AssociatedObject = "awl_AssociatedObject"
}

extension NSOperation: ObjectAssociation {
	public typealias AssociatedObjectType = AnyObject
	public var associatedObject: AssociatedObjectType? {
		get {
			return ObjCAssociation.getValue(self, key: &_NSOperationAssociatedKeys.AssociatedObject)
		}
		set {
			ObjCAssociation.setValueRetain(self, key: &_NSOperationAssociatedKeys.AssociatedObject, value: newValue)
		}
	}
}
