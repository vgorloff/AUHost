//
//  DoubleRepresentable.swift
//  WLCore
//
//  Created by Vlad Gorlov on 18.03.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public protocol DoubleRepresentable {
	var doubleValue: Double { get }
}

extension UInt64: DoubleRepresentable {
	public var doubleValue: Double {
		return Double(self)
	}
}
