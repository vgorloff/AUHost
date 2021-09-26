//
//  BlockDisposable.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public final class BlockDisposable {

   private var handler: (() -> Void)?

   private let lock = NSRecursiveLock()

   public init(_ handler: @escaping () -> Void) {
      self.handler = handler
   }

   deinit {
      dispose()
   }
}

extension BlockDisposable: Disposable {

   public var isDisposed: Bool {
      return handler == nil
   }

   public func dispose() {
      lock.lock()

      handler?()
      handler = nil

      lock.unlock()
   }
}
