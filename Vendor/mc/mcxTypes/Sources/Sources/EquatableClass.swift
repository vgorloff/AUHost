//
//  EquatableClass.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 31.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public protocol EquatableClass: AnyObject, Equatable {

   func isEqual(to other: Self) -> Bool
}

public func == <T>(lhs: T, rhs: T) -> Bool where T: EquatableClass {
   return lhs.isEqual(to: rhs)
}
