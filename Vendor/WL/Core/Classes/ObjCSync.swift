//
//  ObjCSync.swift
//  WLCore
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public final class ObjCSync: NonRecursiveLocking {
	private var _lock = 0
	public init () {
	}
	public final func synchronized<T>(@noescape closure: Void -> T) -> T {
		objc_sync_enter(_lock)
		let result = closure()
		objc_sync_exit(_lock)
		return result
	}
}
