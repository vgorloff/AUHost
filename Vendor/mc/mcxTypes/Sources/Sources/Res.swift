//
//  Res.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05/11/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum Res<T> {

   case success(T)
   case failure(Swift.Error)

   public typealias Completion = (Res<T>) -> Void

   public var error: Swift.Error? {
      switch self {
      case .failure(let error): return error
      case .success: return nil
      }
   }

   public var value: T? {
      switch self {
      case .failure: return nil
      case .success(let result): return result
      }
   }

   public var hasError: Bool {
      switch self {
      case .failure: return true
      case .success: return false
      }
   }

   public func dematerialize() throws -> T {
      switch self {
      case .success(let result):
         return result

      case .failure(let error):
         throw error
      }
   }

   public func map<U>(_ transform: (T) throws -> U) -> Res<U> {
      return flatMap { .success(try transform($0)) }
   }

   public func flatMap<U>(_ transform: (T) throws -> Res<U>) -> Res<U> {
      switch self {
      case .success(let value):
         do {
            return try transform(value)
         } catch {
            return .failure(error)
         }
      case .failure(let error): return .failure(error)
      }
   }

   public func fire(on: DispatchQueue, _ completion: @escaping Completion) {
      on.async {
         completion(self)
      }
   }

   public func fire(_ completion: @escaping Completion) {
      completion(self)
   }

   public func fail<Target>(on: DispatchQueue, _ completion: @escaping (Res<Target>) -> Void) {
      if let error = error {
         on.async {
            completion(.failure(error))
         }
      }
   }

   public func fail<Target>(_ completion: @escaping (Res<Target>) -> Void) {
      if let error = error {
         completion(.failure(error))
      }
   }

   public var voidized: Res<Void> {
      switch self {
      case .failure(let error):
         return .failure(error)
      case .success:
         return .success(())
      }
   }
}
