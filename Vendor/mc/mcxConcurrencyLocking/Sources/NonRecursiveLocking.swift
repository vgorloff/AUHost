//
//  NonRecursiveLocking.swift
//  MCA-OSS-VSTNS;MCA-OSS-AUH
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Darwin
import Foundation

public protocol NonRecursiveLocking {
   func synchronized<T>(_ closure: () -> T) -> T
   func synchronized<T>(_ closure: () throws -> T) throws -> T
}
