//
//  OperationQueue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 Vlad Gorlov. All rights reserved.
//

import Foundation

extension OperationQueue {

   public static func serial(qos: QualityOfService, name: String? = nil) -> OperationQueue {
      let queue = parallel(qos: qos, name: name)
      queue.maxConcurrentOperationCount = 1
      return queue
   }

   public static func parallel(qos: QualityOfService, name: String? = nil) -> OperationQueue {
      let queue = OperationQueue()
      queue.qualityOfService = qos
      queue.name = name
      return queue
   }
}

extension OperationQueue {

   public convenience init(qos: QualityOfService) {
      self.init()
      qualityOfService = qos
   }

   public func addDependentOperations(_ ops: Operation...) {
      addDependentOperations(ops)
   }

   public func addDependentOperations(_ ops: [Operation]) {
      var operations = ops
      while !operations.isEmpty {
         if let previousLast = operations.popLast(), let last = operations.last {
            previousLast.addDependency(last)
         }
      }
      addOperations(ops)
   }

   public func addOperations(_ ops: Operation...) {
      addOperations(ops, waitUntilFinished: false)
   }

   public func addOperations(_ ops: [Operation]) {
      addOperations(ops, waitUntilFinished: false)
   }

   public var isEmpty: Bool {
      return operationCount <= 0
   }

   public func withSuspended(workItem: () -> Void) {
      isSuspended = true
      workItem()
      isSuspended = false
   }
}
