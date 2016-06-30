//
//  NumericTypesConversions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.06.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

//region MARK: Protocols

public protocol IntRepresentable {
	var intValue: Int { get }
}

public protocol Int32Representable {
	var int32Value: Int32 { get }
}

public protocol Int64Representable {
	var int64Value: Int64 { get }
}

public protocol UIntRepresentable {
	var uintValue: UInt { get }
}

public protocol UInt32Representable {
	var uint32Value: UInt32 { get }
}

public protocol UInt64Representable {
	var uint64Value: UInt64 { get }
}

public protocol FloatRepresentable {
	var floatValue: Float { get }
}

public protocol DoubleRepresentable {
	var doubleValue: Double { get }
}

public protocol CGFloatRepresentable {
	var CGFloatValue: CGFloat { get } // swiftlint:disable:this variable_name
}

//endregion

//region MARK: Implementations

extension Int: UInt32Representable {
	public var uint32Value: UInt32 {
		return UInt32(self)
	}
}

extension Int: CGFloatRepresentable {
	public var CGFloatValue: CGFloat { // swiftlint:disable:this variable_name
		return CGFloat(self)
	}
}

extension Int32: UInt32Representable {
	public var uint32Value: UInt32 {
		return UInt32(self)
	}
}

extension Int64: DoubleRepresentable {
	public var doubleValue: Double {
		return Double(self)
	}
}

extension UInt: IntRepresentable {
	public var intValue: Int {
		return Int(self)
	}
}

extension UInt: UInt32Representable {
	public var uint32Value: UInt32 {
		return UInt32(self)
	}
}

extension UInt32: IntRepresentable {
	public var intValue: Int {
		return Int(self)
	}
}

extension UInt32: Int32Representable {
	public var int32Value: Int32 {
		return Int32(self)
	}
}

extension UInt32: UIntRepresentable {
	public var uintValue: UInt {
		return UInt(self)
	}
}

extension UInt32: DoubleRepresentable {
	public var doubleValue: Double {
		return Double(self)
	}
}

extension UInt64: DoubleRepresentable {
	public var doubleValue: Double {
		return Double(self)
	}
}

extension UInt64: Int64Representable {
	public var int64Value: Int64 {
		return Int64(self)
	}
}

extension Float: CGFloatRepresentable {
	public var CGFloatValue: CGFloat { // swiftlint:disable:this variable_name
		return CGFloat(self)
	}
}

extension Double: CGFloatRepresentable {
	public var CGFloatValue: CGFloat { // swiftlint:disable:this variable_name
		return CGFloat(self)
	}
}

extension Double: FloatRepresentable {
	public var floatValue: Float {
		return Float(self)
	}
}

extension Double: Int64Representable {
	public var int64Value: Int64 {
		return Int64(self)
	}
}

extension Double: UInt64Representable {
	public var uint64Value: UInt64 {
		return UInt64(self)
	}
}

//endregion
