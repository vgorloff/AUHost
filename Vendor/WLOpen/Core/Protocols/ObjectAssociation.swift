//
//  ObjectAssociation.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 25.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public protocol ObjectAssociation {
	associatedtype AssociatedObjectType
	var associatedObject: AssociatedObjectType? { get set }
}
