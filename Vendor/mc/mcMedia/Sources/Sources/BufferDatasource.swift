//
//  BufferDatasource.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import MetalKit
import simd

public final class BufferDatasource {

   private var inFlightSemaphore: DispatchSemaphore
   private var inFlightBuffersCount: Int
   private var availableBufferIndex = 0

   public init(inFlightBuffersCount: Int) {
      inFlightSemaphore = DispatchSemaphore(value: inFlightBuffersCount)
      self.inFlightBuffersCount = inFlightBuffersCount
   }

   deinit {
      for _ in 0 ... inFlightBuffersCount {
         inFlightSemaphore.signal()
      }
   }
}

extension BufferDatasource {

   public func nextBuffers(workItem: () throws -> Void) throws {
      try workItem()
      availableBufferIndex += 1
      if availableBufferIndex >= inFlightBuffersCount {
         availableBufferIndex = 0
      }
   }

   public func dispatchWait() {
      inFlightSemaphore.wait()
   }

   public func dispatchSignal() {
      inFlightSemaphore.signal()
   }
}
