//
//  ObjectAssociation.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

public protocol ObjectAssociation {
   associatedtype AssociatedObjectType
   var associatedObject: AssociatedObjectType? { get set }
}
