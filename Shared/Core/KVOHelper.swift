//
//  KVOHelper.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public struct KVOHelperResult<T: Any> {
	private var changeKind: NSKeyValueChange
	public var change: [NSKeyValueChangeKey: Any]
	public var kind: NSKeyValueChange {
		return changeKind
	}
	public var valueNew: T? {
		return change[.newKey] as? T
	}
	public var valueOld: T? {
		return change[.oldKey] as? T
	}
	var isPrior: Bool {
		return (change[.notificationIsPriorKey] as? NSNumber)?.boolValue ?? false
	}
	var indexes: NSIndexSet? {
		return change[.indexesKey] as? NSIndexSet
	}
	init?(change aChange: [NSKeyValueChangeKey: Any]) {
		change = aChange
		guard
			let changeKindNumberValue = change[.kindKey] as? NSNumber,
			let changeKindEnumValue = NSKeyValueChange.init(rawValue: changeKindNumberValue.uintValue) else {
				return nil
		}
		changeKind = changeKindEnumValue
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

	public typealias ChangeCallback = (KVOHelperResult<T>) -> Void

	private var context = 0
	private var object: NSObject
	private var keyPath: String
	private var options: NSKeyValueObservingOptions
	private var changeCallback: ChangeCallback

	public var suspended = false // TODO: Maybe there is needed Thread-Safe implementation. By Vlad Gorlov, Jan 13, 2016.

   public init(object anObject: NSObject, keyPath aKeyPath: String, options anOptions: NSKeyValueObservingOptions = .new,
               changeCallback aCallback: @escaping ChangeCallback) {
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

	override public func observeValue(forKeyPath aKeyPath: String?, of object: Any?,
	                                  change aChange: [NSKeyValueChangeKey : Any]?, context aContext: UnsafeMutableRawPointer?) {
			if aContext == &context && aKeyPath == keyPath {
				if !suspended, let change = aChange, let result = KVOHelperResult<T>(change: change) {
					changeCallback(result)
				}
			} else {
				super.observeValue(forKeyPath: keyPath, of: object, change: aChange, context: aContext)
			}
	}
}
