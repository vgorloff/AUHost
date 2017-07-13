//
//  ResultType.swift
//  WaveLabs
//
//  Created by VG (DE) on 05/11/2016.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public enum ResultType<T> {

   public typealias Completion = (ResultType<T>) -> Void

   case success(T)
   case failure(Swift.Error)

   public static func `do`(_ completion: Completion?, closure: (() throws -> Void)) {
      do {
         try closure()
      } catch {
         completion?(.failure(error))
      }
   }

   public var error: Swift.Error? {
      switch self {
      case .failure(let e): return e
      case .success: return nil
      }
   }

   public var result: T? {
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

   public var resultType: ResultType<Void> {
      switch self {
      case .failure(let e): return .failure(e)
      case .success: return .success(())
      }
   }
}
