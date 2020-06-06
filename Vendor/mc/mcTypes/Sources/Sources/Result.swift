//
//  Result.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05/11/2016.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public enum Result<T> {

   case success(T)
   case failure(Swift.Error)

   public typealias Completion = (Result<T>) -> Void

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

   public func map<U>(_ transform: (T) throws -> U) -> Result<U> {
      return flatMap { .success(try transform($0)) }
   }

   public func flatMap<U>(_ transform: (T) throws -> Result<U>) -> Result<U> {
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
}
