//
//  KVOHelper.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public struct KVOHelperResult<T: Any> {
	private var _kind: NSKeyValueChange
	public var change: [String : AnyObject]
	public var kind: NSKeyValueChange {
		return _kind
	}
	public var valueNew: T? {
		return change[NSKeyValueChangeNewKey] as? T
	}
	public var valueOld: T? {
		return change[NSKeyValueChangeOldKey] as? T
	}
	var isPrior: Bool {
		return (change[NSKeyValueChangeNotificationIsPriorKey] as? NSNumber)?.boolValue ?? false
	}
	var indexes: NSIndexSet? {
		return change[NSKeyValueChangeIndexesKey] as? NSIndexSet
	}
	init?(change aChange: [String : AnyObject]) {
		change = aChange
		guard
			let changeKind = change[NSKeyValueChangeKindKey] as? NSNumber,
			let lKind = NSKeyValueChange.init(rawValue: changeKind.unsignedIntegerValue) else {
				return nil
		}
		_kind = lKind
	}
}

/// - SeeAlso: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual
/// BuildingCocoaApps/AdoptingCocoaDesignPatterns.html
///~~~
///let observer = KVOHelper(object: mediaLibrary, keyPath: "mediaSources") { result in
///    // Do something
///}
///~~~
public final class KVOHelper<T: Any>: NSObject {

	public typealias ChangeCallback = KVOHelperResult<T> -> Void

	private var context = 0
	private var object: NSObject
	private var keyPath: String
	private var options: NSKeyValueObservingOptions
	private var changeCallback: ChangeCallback

	public var suspended = false // TODO: Maybe there is needed Thread-Safe implementation. By Vlad Gorlov, Jan 13, 2016.

	public init(object anObject: NSObject, keyPath aKeyPath: String, options anOptions: NSKeyValueObservingOptions = .New,
		changeCallback aCallback: ChangeCallback) {
		object = anObject
		keyPath = aKeyPath
		options = anOptions
		changeCallback = aCallback
		super.init()
		object.addObserver(self, forKeyPath: keyPath, options: options, context: &context)
	}

	deinit {
		object.removeObserver(self, forKeyPath: keyPath, context: &context)
	}

	override public func observeValueForKeyPath(aKeyPath: String?, ofObject object: AnyObject?,
		change aChange: [String : AnyObject]?, context aContext: UnsafeMutablePointer<Void>) {
			if aContext == &context && aKeyPath == keyPath {
				if !suspended, let change = aChange, let result = KVOHelperResult<T>(change: change) {
					changeCallback(result)
				}
			} else {
				super.observeValueForKeyPath(keyPath, ofObject: object, change: aChange, context: aContext)
			}
	}
}
