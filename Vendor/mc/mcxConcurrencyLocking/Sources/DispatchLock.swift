//
//  DispatchLock.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

@available(*, message: "Too slow. Use other lock")
public final class DispatchLock: NonRecursiveLocking {

   private let lockQueue = DispatchQueue(label: "ua.com.wavelabs.lockingQueue")

   public init() {
   }

   public final func synchronized<T>(_ closure: () -> T) -> T {
      var result: T!
      lockQueue.sync {
         result = closure()
      }
      return result
   }

   public func synchronized<T>(_ closure: () throws -> T) throws -> T {
      var result: Result<T, Error>!
      lockQueue.sync {
         do {
            result = .success(try closure())
         } catch {
            result = .failure(error)
         }
      }
      return try result.get()
   }
}
