//
//  FetchedResultsTableViewDataSource.swift
//  WLData
//
//  Created by Vlad Gorlov on 03.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import CoreData
import UIKit

public class FetchedResultsTableViewDataSource<T: NSManagedObject>: NSObject,
UITableViewDataSource, NSFetchedResultsControllerDelegate {

	private lazy var log: Logger = {[unowned self] in return Logger(sender: self, context: .Delegate)}()
	private var _tableView: UITableView
	private var _fetchedResultsController: NSFetchedResultsController
	private lazy var _registryForNibs = [String: UINib]()

	public var tableView: UITableView {
		return _tableView
	}
	public var fetchedResultsController: NSFetchedResultsController {
		return _fetchedResultsController
	}

	public var reusableCellClassBlock: ((object: T) -> AnyClass)?
	public var reusableCellIdentifierBlock: ((object: T) -> String)?
	public var configureCellBlock: ((cell: UITableViewCell, object: T) -> Void)?
	public var willBeginUpdates: (Void -> Void)?
	public var didEndUpdates: (Void -> Void)?
	public var onObjectInsert: ((object: T, newIndexPath: NSIndexPath) -> Void)?
	public var onObjectUpdate: ((object: T, indexPath: NSIndexPath) -> Void)?
	public var onObjectMove: ((object: T, fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) -> Void)?
	public var onObjectDelete: ((object: T, indexPath: NSIndexPath) -> Void)?
	public var rowAnimationBlock: ((object: T, indexPath: NSIndexPath,
		contentsChangeEvent: UITableViewContentsChangeEvent) -> UITableViewRowAnimation)?

	private var tableStateFlag = ThreeStateFlag.FladUndefined
	public var totalNumberOfObjects: Int {
		var result = 0
		let numberOfSections = numberOfSectionsInTableView(_tableView)
		for section in 0..<numberOfSections {
			result += _fetchedResultsController.sections?[section].numberOfObjects ?? 0
		}
		return result
	}

	public var visibleCellsObjectIDs: Set<NSManagedObjectID> {
		var objectIDsOfVisibleCells = Set<NSManagedObjectID>()
		guard let pathsArray = tableView.indexPathsForVisibleRows else {
			return objectIDsOfVisibleCells
		}
		for ip in pathsArray {
			let entity = objectAtIndexPath(ip)
			objectIDsOfVisibleCells.insert(entity.objectID)
		}
		return objectIDsOfVisibleCells
	}

	public init(tableView: UITableView, fetchedResultsController: NSFetchedResultsController) {
		_tableView = tableView
		_fetchedResultsController = fetchedResultsController
		super.init()
		_fetchedResultsController.delegate = self
		_tableView.dataSource = self
		log.logInit()
	}

	deinit {
		log.logDeinit()
		_fetchedResultsController.delegate = nil
		_tableView.dataSource = nil
		_registryForNibs.removeAll()
		reusableCellIdentifierBlock = nil
		reusableCellClassBlock = nil
		configureCellBlock = nil
		willBeginUpdates = nil
		didEndUpdates = nil
		onObjectInsert = nil
		onObjectUpdate = nil
		onObjectMove = nil
		onObjectDelete = nil
		rowAnimationBlock = nil
	}

	// MARK: - Utility functions

	public func indexPathForVisibleCellWithObjectID(objectID: NSManagedObjectID) -> NSIndexPath? {
		guard let pathsArray = tableView.indexPathsForVisibleRows else {
			return nil
		}
		for ip in pathsArray {
			let entity = objectAtIndexPath(ip)
			if entity.objectID.isEqual(objectID) {
				return ip
			}
		}
		return nil
	}

	public func reusableCellIdentifierForClass(cellClass: AnyClass) -> String {
		return StringFromClass(cellClass)
	}

	public func registerNib(nib: UINib, forCellClass: AnyClass) {
		let cellReuseIdentifier = reusableCellIdentifierForClass(forCellClass)
		_tableView.registerNib(nib, forCellReuseIdentifier: cellReuseIdentifier)
		_registryForNibs[cellReuseIdentifier] = nib
	}

	public func nibForCellClass(cellClass: AnyClass) -> UINib {
		let cellReuseIdentifier = reusableCellIdentifierForClass(cellClass)
		guard let nib = _registryForNibs[cellReuseIdentifier] else {
			fatalError("UINib for reusable identifier \"\(cellReuseIdentifier)\" is not found.")
		}
		return nib
	}

	public func objectAtIndexPath(indexPath: NSIndexPath) -> T {
		let object = _fetchedResultsController.objectAtIndexPath(indexPath)
		guard let entity = object as? T else {
			fatalError("Unexpected object type: \(object)")
		}
		return entity
	}

	public func reusableCellIdentifierForObject(object: T) -> String {
		var reusableCellID: String?
		if let cellClass = reusableCellClassBlock?(object: object) {
			reusableCellID = reusableCellIdentifierForClass(cellClass)
		} else {
			reusableCellID = reusableCellIdentifierBlock?(object: object)
		}
		guard let cellID = reusableCellID else {
			fatalError("Can't determinate reusable cell identifier." +
				"Please set reusableCellClassBlock or reusableCellIdentifierBlock callbacks")
		}
		return cellID
	}

	// MARK: - UITableViewDataSource

	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		let numberOfSections = _fetchedResultsController.sections?.count ?? 0
		return numberOfSections
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfObjects = _fetchedResultsController.sections?[section].numberOfObjects ?? 0
		return numberOfObjects
	}

	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let entity = objectAtIndexPath(indexPath)
		let cellID = reusableCellIdentifierForObject(entity)
		let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
		if let configCellBlock = configureCellBlock {
			configCellBlock(cell: cell, object: entity)
		}
		return cell
	}


	// MARK: - NSFetchedResultsControllerDelegate

	public func controllerWillChangeContent(controller: NSFetchedResultsController) {
		willBeginUpdates?()
		_tableView.beginUpdates()
	}

	public func controllerDidChangeContent(controller: NSFetchedResultsController) {
		_tableView.endUpdates()
		didEndUpdates?()
	}

	public func controller(controller: NSFetchedResultsController, didChangeObject: AnyObject,
		atIndexPath: NSIndexPath?, forChangeType: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
			guard let o = didChangeObject as? T else {
				fatalError()
			}
			switch forChangeType {
			case .Insert:
				let ip = newIndexPath!
				let animation = rowAnimationBlock?(object: o, indexPath: ip, contentsChangeEvent: .Insert) ?? .Automatic
				onObjectInsert?(object: o, newIndexPath: ip)
				_tableView.insertRowsAtIndexPaths([ip], withRowAnimation: animation)
			case .Update:
				let ip = atIndexPath!
				let animation = rowAnimationBlock?(object: o, indexPath: ip, contentsChangeEvent: .Reload) ?? .Automatic
				onObjectUpdate?(object: o, indexPath: ip)
				_tableView.reloadRowsAtIndexPaths([ip], withRowAnimation: animation)
			case .Move:
				let ipFrom = atIndexPath!
				let ipTo = newIndexPath!
				onObjectMove?(object: o, fromIndexPath: ipFrom, toIndexPath: ipTo)
//				_tableView.deleteRowsAtIndexPaths([ipFrom], withRowAnimation: .Automatic)
//				_tableView.insertRowsAtIndexPaths([ipTo], withRowAnimation: .Automatic)
				_tableView.moveRowAtIndexPath(ipFrom, toIndexPath: ipTo)
			case .Delete:
				let ip = atIndexPath!
				let animation = rowAnimationBlock?(object: o, indexPath: ip, contentsChangeEvent: .Delete) ?? .Automatic
				onObjectDelete?(object: o, indexPath: ip)
				_tableView.deleteRowsAtIndexPaths([ip], withRowAnimation: animation)
			}
	}

}
