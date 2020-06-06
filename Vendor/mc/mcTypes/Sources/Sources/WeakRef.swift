//
//  WeakRef.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

// See:
// Swift Tip: Weak Arrays · objc.io: https://www.objc.io/blog/2017/12/28/weak-arrays/
// Swift Arrays Holding Elements With Weak References: https://marcosantadev.com/swift-arrays-holding-elements-weak-references/
public final class WeakRef<A: AnyObject> {

   public private(set) weak var value: A?

   public init(_ value: A) {
      self.value = value
   }

   public func `do`(workItem: (A) -> Void) {
      if let instance = value {
         workItem(instance)
      }
   }
}
