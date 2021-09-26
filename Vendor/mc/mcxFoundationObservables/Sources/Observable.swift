//
//  Observable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.02.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation

public protocol Observable {
   var isSuspended: Bool { get set }
   func dispose()
}

extension Array where Element == Observable {

   public func suspend() {
      forEach {
         var observer = $0
         observer.isSuspended = true
      }
   }

   public func resume() {
      forEach {
         var observer = $0
         observer.isSuspended = false
      }
   }
}
