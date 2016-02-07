//
//  UIUpdatable.swift
//  WLUI
//
//  Created by Vlad Gorlov on 29.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public protocol UIUpdatable {
	typealias ModelObjectType
	func updateWithObject(modelObject: ModelObjectType)
}
