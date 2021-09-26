//
//  UIUpdatable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

public protocol UIUpdatable {
   associatedtype ModelObjectType
   func updateWithObject(modelObject: ModelObjectType)
}
