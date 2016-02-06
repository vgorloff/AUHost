//
//  UIConfigurable.swift
//  WLUI
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public protocol UIConfigurable {
	typealias ModelObjectType
	func setupWithObject(modelObject: ModelObjectType)
}
