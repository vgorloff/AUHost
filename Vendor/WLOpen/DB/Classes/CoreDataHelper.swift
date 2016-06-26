/// File: CoreDataHelper.swift
/// Project: WLData
/// Author: Created by Vlad Gorlov on 13.02.15.
/// Copyright: Copyright (c) 2015 WaveLabs. All rights reserved.

import CoreData

public struct CoreDataHelper {

	public static func saveContext (moc: NSManagedObjectContext) throws {
		if moc.hasChanges {
			try moc.save()
		}
	}

	public static func deleteAllEntities(name: String, managedObjectContext moc: NSManagedObjectContext) {
		let fetchRequest = NSFetchRequest(entityName: name)
		fetchRequest.includesPropertyValues = false
		CoreDataHelper.executeFetchRequestAndDeleteRecords(fetchRequest, managedObjectContext: moc)
	}

	public static func executeFetchRequestAndDeleteRecords(fetchRequest: NSFetchRequest,
		managedObjectContext moc: NSManagedObjectContext) {
			guard let results = trythrow(try moc.executeFetchRequest(fetchRequest)) as? [NSManagedObject] else {
				return
			}
			for result in results {
				moc.deleteObject(result)
			}
	}

	public static func addOrUpdateRecordsWithEntities<T: NSManagedObject where T: MergableEntity,
		T.MergableEntityType == T>(entities: [T], managedObjectContext moc: NSManagedObjectContext) -> [T] {

			if entities.count <= 0 {
				return []
			}

			let entitiesFromResponse = entities.sort { lhs, rhs in
				return lhs.uniqueValue < rhs.uniqueValue
			}

			let fetchRequest = NSFetchRequest(entityName: T.entityName)
			fetchRequest.predicate = T.predicateForMergeWithEntities(entitiesFromResponse)
			fetchRequest.sortDescriptors = T.sortDescriptorsForMergeWithEntities(entitiesFromResponse)
			fetchRequest.includesPendingChanges = false

			guard let entitiesFromDatabase = trythrow(try moc.executeFetchRequest(fetchRequest)) as? [T] else {
				return []
			}
			if entitiesFromDatabase.count <= 0 {
				return entitiesFromResponse
			}

			var updatedOrInsertedEntities = [T]()
			var iteratorForDatabase = entitiesFromDatabase.generate()
			var iteratorForResponse = entitiesFromResponse.generate()
			var entityFromDatabase = iteratorForDatabase.next()
			var entityFromResponse = iteratorForResponse.next()
			repeat {
				guard
					let eFromDatabase = entityFromDatabase,
					let eFromResponse = entityFromResponse else {
					break
				}
				if eFromDatabase.uniqueValue == eFromResponse.uniqueValue {
					if eFromDatabase.shouldMerge(eFromResponse) {
						eFromDatabase.merge(eFromResponse)
						updatedOrInsertedEntities.append(eFromDatabase)
					}
					moc.deleteObject(eFromResponse)
					entityFromDatabase = iteratorForDatabase.next()
					entityFromResponse = iteratorForResponse.next()
				} else {
					updatedOrInsertedEntities.append(eFromResponse)
					entityFromResponse = iteratorForResponse.next()
				}

			} while (true)

			// Continue inserting if there are still available new entries from server
			while let entity = entityFromResponse {
				updatedOrInsertedEntities.append(entity)
				entityFromResponse = iteratorForResponse.next()
			}

			return updatedOrInsertedEntities
	}

}
