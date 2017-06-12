//
//  DispatchSemaphore.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension DispatchSemaphore {
  public func wait(completion: () -> Void) {
    wait()
    completion()
  }
}
