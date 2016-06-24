//
//  Int64Representable.swift
//  WLCore
//
//  Created by Vlad Gorlov on 18.03.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public protocol Int64Representable {
	var int64Value: Int64 { get }
}

extension UInt64: Int64Representable {
	public var int64Value: Int64 {
		return Int64(self)
	}
}

extension Double: Int64Representable {
	public var int64Value: Int64 {
		return Int64(self)
	}
}
