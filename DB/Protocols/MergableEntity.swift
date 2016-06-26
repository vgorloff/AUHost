//
//  MergableEntity.swift
//  WLData
//
//  Created by Volodymyr Gorlov on 25.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public protocol MergableEntity: UniqueByString {
	associatedtype MergableEntityType
	static var entityName: String { get }
	static func predicateForMergeWithEntities(others: [MergableEntityType]) -> NSPredicate
	static func sortDescriptorsForMergeWithEntities(others: [MergableEntityType]) -> [NSSortDescriptor]
	func merge(other: MergableEntityType)
	func shouldMerge(other: MergableEntityType) -> Bool
}
