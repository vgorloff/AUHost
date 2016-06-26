//
//  UInt64Representable.swift
//  WLCore
//
//  Created by Vlad Gorlov on 18.03.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public protocol UInt64Representable {
	var uint64Value: UInt64 { get }
}

extension Double: UInt64Representable {
	public var uint64Value: UInt64 {
		return UInt64(self)
	}
}
