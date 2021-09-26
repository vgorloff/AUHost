//
//  Disposable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public protocol Disposable {
   var isDisposed: Bool { get }
   func dispose()
}
