//
//  NonRecursiveLocking.swift
//  mcCore
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Darwin
import Foundation

public protocol NonRecursiveLocking {
   func synchronized<T>(_ closure: () -> T) -> T
}
