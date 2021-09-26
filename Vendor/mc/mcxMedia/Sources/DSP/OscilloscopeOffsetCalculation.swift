//
//  OscilloscopeOffsetCalculation.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.09.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

struct OscilloscopeOffsetCalculation {

   struct BufferInfo {
      let processingOffset: Int
      let processingFrames: Int
      let processingIterations: Int
      let unprocessedFrames: Int
   }

   struct TailInfo {
      let pendingFrames: Int
      let processingFrames: Int
      let processingIterations: Int
      let unprocessedFrames: Int
   }

   let buffer: BufferInfo
   let tail: TailInfo

   init() {
      buffer = BufferInfo(processingOffset: 0, processingFrames: 0, processingIterations: 0, unprocessedFrames: 0)
      tail = TailInfo(pendingFrames: 0, processingFrames: 0, processingIterations: 0, unprocessedFrames: 0)
   }

   init(numberOfFrames: Int, framesInGroup: Int, pendingFrames: Int) {

      var numberOfFramesUsedToCompletePendingGroup: Int
      do {
         if pendingFrames > 0 {
            let maximumAvailable = pendingFrames + numberOfFrames
            let processable: Int
            var incomplete: Int
            if maximumAvailable >= framesInGroup {
               incomplete = pendingFrames % framesInGroup
               if incomplete > 0 {
                  numberOfFramesUsedToCompletePendingGroup = framesInGroup - incomplete
                  processable = pendingFrames + numberOfFramesUsedToCompletePendingGroup
                  incomplete = 0
               } else {
                  processable = pendingFrames
                  numberOfFramesUsedToCompletePendingGroup = 0
               }
            } else {
               processable = 0
               incomplete = maximumAvailable
               numberOfFramesUsedToCompletePendingGroup = numberOfFrames
            }

            let iterations = processable / framesInGroup
            tail = TailInfo(pendingFrames: pendingFrames, processingFrames: processable,
                            processingIterations: iterations, unprocessedFrames: incomplete)
         } else {
            numberOfFramesUsedToCompletePendingGroup = 0
            tail = TailInfo(pendingFrames: 0, processingFrames: 0, processingIterations: 0, unprocessedFrames: 0)
         }
      }

      do {
         let offset = numberOfFramesUsedToCompletePendingGroup
         let available = numberOfFrames - offset

         let processable: Int
         let incomplete = available % framesInGroup
         if incomplete > 0 {
            processable = available - incomplete
         } else {
            processable = available
         }
         let iterations = processable / framesInGroup
         buffer = BufferInfo(processingOffset: offset, processingFrames: processable, processingIterations: iterations,
                             unprocessedFrames: incomplete)
      }
   }
}

extension OscilloscopeOffsetCalculation {

   var unprocessedFramesBufferSize: Int {
      return max(buffer.unprocessedFrames, tail.unprocessedFrames)
   }

   var unprocessedFramesBufferNumberOfFramesToWrite: Int {
      if tail.unprocessedFrames > 0 {
         return tail.unprocessedFrames - tail.pendingFrames
      } else {
         return buffer.unprocessedFrames
      }
   }
}
