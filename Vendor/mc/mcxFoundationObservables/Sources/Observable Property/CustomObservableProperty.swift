//
//  CustomObservableProperty.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxTypes

public final class CustomObservableProperty<T> {

   public typealias Observer = (T) -> Void

   public var value: T {
      willSet {
         willSet?(value, newValue)
      }
      didSet {
         container.fire(value)
         didSet?(oldValue, value)
      }
   }

   private let container = ObserversContainer<T>()
   private let willSet: ((_ old: T, _ new: T) -> Void)?
   private let didSet: ((_ old: T, _ new: T) -> Void)?

   public init(_ value: T, willSet: ((_ old: T, _ new: T) -> Void)? = nil, didSet: ((_ old: T, _ new: T) -> Void)? = nil) {
      self.value = value
      self.willSet = willSet
      self.didSet = didSet
   }

   public func addObserver(fireWithInitialValue: Bool = true,
                           on queue: DispatchQueue? = nil,
                           _ observer: @escaping Observer) -> Disposable {
      let result = container.addObserver(on: queue, observer)
      if fireWithInitialValue {
         if let queue = queue {
            queue.async { observer(self.value) }
         } else {
            observer(value)
         }
      }
      return result
   }

   public func removeAllObservers() {
      container.removeAllObservers()
   }

   public func setValue(_ value: T, on: DispatchQueue) {
      on.async {
         self.value = value
      }
   }

   public func set(_ value: T) {
      self.value = value
   }
}
