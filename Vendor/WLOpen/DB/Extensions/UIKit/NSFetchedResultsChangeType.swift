//
//  NSFetchedResultsChangeType.swift
//  WLData
//
//  Created by Volodymyr Gorlov on 30.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import CoreData

extension NSFetchedResultsChangeType: StringRepresentable {

	public var stringValue: String {
		switch self {
		case .Insert:
			return "Insert"
		case .Delete:
			return "Delete"
		case .Update:
			return "Update"
		case .Move:
			return "Move"
		}
	}

}
