//
//  UIConfigurable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

public protocol UIConfigurable {
   associatedtype ModelObjectType
   func setupWithObject(modelObject: ModelObjectType)
}
