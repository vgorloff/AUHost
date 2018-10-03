//
//  Operation.swift
//  mcCore
//
//  Created by VG (DE) on 02/02/2017.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

extension Operation {

   @discardableResult
   public func then(_ op: Operation) -> Operation {
      op.addDependency(self)
      return op
   }
}

extension Operation {

   private struct Key {
      static var id = "com.mc.id"
   }

   public var id: String? {
      get {
         return ObjCAssociation.value(from: self, forKey: &Key.id)
      } set {
         ObjCAssociation.setCopyNonAtomic(value: newValue, to: self, forKey: &Key.id)
      }
   }
}
