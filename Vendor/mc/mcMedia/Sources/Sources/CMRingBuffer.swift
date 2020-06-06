//
//  CMRingBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import CoreMedia
import Foundation
import mcFoundation

private func getDurationCallback(_: CMBuffer, _: UnsafeMutableRawPointer?) -> CMTime {
//   if let refcon = refcon {
//      let ringBuffer = Unmanaged<CMRingBuffer>.fromOpaque(refcon).takeUnretainedValue()
//      return CMTime(seconds: 200, preferredTimescale: 1)
//   } else {
//      assert(false)
//      return CMTime(seconds: 0, preferredTimescale: 1)
//   }
   fatalError("Not Implemented")
}

public class CMRingBuffer {

   public enum Error: Swift.Error {
      case unableToInitialize
   }

   private var callbacks: CMBufferCallbacks!
   private var queue: CMBufferQueue!

   public init() throws {
      try initializeQueue()
   }
}

extension CMRingBuffer {

   public var isEmpty: Bool {
      return CMBufferQueueIsEmpty(queue)
   }

   public var totalSize: Int {
      return CMBufferQueueGetTotalSize(queue)
   }

   public var bufferCount: CMItemCount {
      return CMBufferQueueGetBufferCount(queue)
   }

   public var maxPresentationTimeStamp: CMTime {
      return CMBufferQueueGetMaxPresentationTimeStamp(queue)
   }

   public var duration: CMTime {
      return CMBufferQueueGetDuration(queue)
   }

   public var typeID: CFTypeID {
      return CMBufferQueueGetTypeID()
   }

   public func enqueue(buffer: CMBuffer) -> OSStatus {
      return CMBufferQueueEnqueue(queue, buffer: buffer)
   }
}

extension CMRingBuffer {

   private func initializeQueue() throws {
      let context = Unmanaged.passUnretained(self).toOpaque()
      callbacks = CMBufferCallbacks(version: 0, refcon: context,
                                    getDecodeTimeStamp: nil, getPresentationTimeStamp: nil,
                                    getDuration: getDurationCallback, isDataReady: nil, compare: nil,
                                    dataBecameReadyNotification: nil, getSize: nil)
      var queueRef: CMBufferQueue?
      let code = CMBufferQueueCreate(allocator: kCFAllocatorDefault, capacity: 2000, callbacks: &callbacks, queueOut: &queueRef)
      if let error = OSError(code: code) {
         throw error
      }
      guard let queue = queueRef else {
         throw Error.unableToInitialize
      }
      self.queue = queue
   }
}
