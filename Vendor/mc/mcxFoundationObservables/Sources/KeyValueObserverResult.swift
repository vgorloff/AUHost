//
//  KeyValueObserverResult.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.02.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct KeyValueObserverResult<T: Any> {

   public private(set) var change: [NSKeyValueChangeKey: Any]

   public private(set) var kind: NSKeyValueChange

   init?(change: [NSKeyValueChangeKey: Any]) {
      self.change = change
      guard
         let changeKindNumberValue = change[.kindKey] as? NSNumber,
         let changeKindEnumValue = NSKeyValueChange(rawValue: changeKindNumberValue.uintValue)
      else {
         return nil
      }
      kind = changeKindEnumValue
   }

   // MARK: -

   public var valueNew: T? {
      return change[.newKey] as? T
   }

   public var valueOld: T? {
      return change[.oldKey] as? T
   }

   var isPrior: Bool {
      return (change[.notificationIsPriorKey] as? NSNumber)?.boolValue ?? false
   }

   var indexes: NSIndexSet? {
      return change[.indexesKey] as? NSIndexSet
   }
}
