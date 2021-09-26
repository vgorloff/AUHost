//
//  DisposeBag.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

// FIXME: Rename to DisposableContainer.
public final class DisposeBag {

   public var isEmpty: Bool {
      return items.isEmpty
   }

   private var items: [Disposable] = []

   public init() {
   }

   deinit {
      dispose()
   }
}

extension DisposeBag {

   public func add(_ item: Disposable) {
      items.append(item)
   }

   public func dispose() {
      items.forEach { $0.dispose() }
      items.removeAll(keepingCapacity: true)
   }

   public static func += (left: DisposeBag, right: Disposable) {
      left.add(right)
   }

   public static func += (left: DisposeBag, right: Disposable?) {
      if let right = right {
         left.add(right)
      }
   }
}
