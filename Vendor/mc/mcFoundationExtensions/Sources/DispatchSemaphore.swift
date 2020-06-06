//
//  DispatchSemaphore.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension DispatchSemaphore {
   public func wait(completion: () -> Void) {
      wait()
      completion()
   }
}
