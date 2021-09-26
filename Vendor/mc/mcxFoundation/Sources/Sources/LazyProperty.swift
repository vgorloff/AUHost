//
//  LazyProperty.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24/05/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

// Instead of standard Swift lazy property this class allow to "reset" property to nil.
public class LazyProperty<T> {

   private let mInitializer: () -> T
   private var mValue: T?

   public var value: T {
      get {
         var result: T
         if let resultValue = mValue {
            result = resultValue
         } else {
            result = mInitializer()
            mValue = result
         }
         return result
      } set {
         mValue = newValue
      }
   }

   public required init(initializer: @escaping () -> T) {
      mInitializer = initializer
   }

   public func reset() {
      mValue = nil
   }
}
