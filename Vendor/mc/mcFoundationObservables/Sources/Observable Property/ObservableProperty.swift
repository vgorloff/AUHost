//
//  ObservableProperty.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public typealias ObservableProperty = NotificationsBasedObservableProperty

extension ObservableProperty where T == Bool {

   public func toggle() {
      value = !value
   }
}

@propertyWrapper
public class ObservableValue<T> {

   private let observable: ObservableProperty<T>

   public init(_ defaultValue: T) {
      observable = ObservableProperty(defaultValue)
   }

   public var wrappedValue: T {
      get {
         return observable.value
      } set {
         observable.value = newValue
      }
   }

   public var projectedValue: ObservableProperty<T> {
      return observable
   }
}
