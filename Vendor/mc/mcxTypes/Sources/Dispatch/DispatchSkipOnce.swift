//
//  DispatchSkipOnce.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 11/01/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public final class DispatchSkipOnce {

   private var isInitialized = false

   public init() {
   }

   public func perform(block: () -> Void) {
      if !isInitialized {
         isInitialized = true
         return
      }
      block()
   }
}
