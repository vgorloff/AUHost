//
//  ObjCAssociation.swift
//  WLCore
//
//  Created by Vlad Gorlov on 03.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

private final class ObjCAssociationValueWrapper<T> {
	let value: T
	init(_ aValue: T) {
		value = aValue
	}
}

public struct ObjCAssociation {
	public static func getValue<T>(object: AnyObject, key: UnsafePointer<Void>) -> T? {
		if let warpper = objc_getAssociatedObject(object, key) as? ObjCAssociationValueWrapper<T> {
			return warpper.value
		} else if let value = objc_getAssociatedObject(object, key) as? T {
			return value
		} else {
			return nil
		}
	}
	private static func setValue<T>(object: AnyObject, key: UnsafePointer<Void>, value: T?, policy: objc_AssociationPolicy) {
		if value == nil {
			objc_setAssociatedObject(object, key, nil, policy)
		} else if let objectValue = value as? AnyObject {
			objc_setAssociatedObject(object, key, objectValue, policy)
		} else {
			objc_setAssociatedObject(object, key, ObjCAssociationValueWrapper(value), policy)
		}
	}
	public static func setValueAssign<T>(object: AnyObject, key: UnsafePointer<Void>, value: T?) {
		setValue(object, key: key, value: value, policy: .OBJC_ASSOCIATION_ASSIGN)
	}
	public static func setValueRetainNonAtomic<T>(object: AnyObject, key: UnsafePointer<Void>, value: T?) {
		setValue(object, key: key, value: value, policy: .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
	public static func setValueCopyNonAtomic<T>(object: AnyObject, key: UnsafePointer<Void>, value: T?) {
		setValue(object, key: key, value: value, policy: .OBJC_ASSOCIATION_COPY_NONATOMIC)
	}
	public static func setValueRetain<T>(object: AnyObject, key: UnsafePointer<Void>, value: T?) {
		setValue(object, key: key, value: value, policy: .OBJC_ASSOCIATION_RETAIN)
	}
	public static func setValueCopy<T>(object: AnyObject, key: UnsafePointer<Void>, value: T?) {
		setValue(object, key: key, value: value, policy: .OBJC_ASSOCIATION_COPY)
	}
}
