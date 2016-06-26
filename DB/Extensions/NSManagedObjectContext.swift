//
//  NSManagedObjectContext.swift
//  WLData
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import CoreData

public extension NSManagedObjectContext {
	private struct AssociatedKeys {
		static var DescriptiveName = "awl_DescriptiveName"
	}
	var descriptiveName: String {
		get {
			return ObjCAssociation.getValue(self,
				key: &AssociatedKeys.DescriptiveName) ?? String(format: "%p", pointerAddressOf(self))
		}
		set {
			ObjCAssociation.setValueCopyNonAtomic(self, key: &AssociatedKeys.DescriptiveName, value: newValue)
		}
	}
	func describeChanges() -> [String: Int] {
		return [
			"insertedObjects.count": insertedObjects.count,
			"deletedObjects.count": deletedObjects.count,
			"updatedObjects.count": updatedObjects.count
		]
	}
}
