//
//  NonRecursiveLocking.swift
//  WLCore
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public protocol NonRecursiveLocking {
	func synchronized<T>(@noescape closure: Void -> T) -> T
}
