//
//  Publisher.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Combine
import Foundation

enum PublisherWaitError: Swift.Error {
   case timedOut
   case noResult
}

@available(OSX 10.15, iOS 13.0, *)
extension Publisher {

   public func wait(on queue: DispatchQueue? = nil, timeout: TimeInterval = 60) throws -> Output {
      let queue = queue ?? DispatchQueue(label: "app.publisher.wait", qos: .default)
      var cancellable: AnyCancellable?
      let semaphore = DispatchSemaphore(value: 0)
      var resultError: Failure?
      var resultValue: Output?
      cancellable = receive(on: queue).sink(receiveCompletion: {
         switch $0 {
         case .failure(let error):
            resultError = error
         case .finished:
            break
         }
         semaphore.signal()
      }, receiveValue: {
         resultValue = $0
      })
      let status = semaphore.wait(timeout: .now() + timeout)
      if status == .timedOut {
         throw PublisherWaitError.timedOut
      }
      cancellable = nil
      _ = cancellable
      if let error = resultError {
         throw error
      } else if let value = resultValue {
         return value
      } else {
         throw PublisherWaitError.noResult
      }
   }
}
