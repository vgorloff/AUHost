//
//  MediaBufferCollection.swift
//  WLTests
//
//  Created by Vlad Gorlov on 11.09.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

public final class MediaBufferCollection<T: DefaultInitializerType> {

   public private(set) var numberOfBuffers: Int
   public private(set) var numberOfElements: Int

   private var maxNumberOfElements: Int = 0

   private var buffer: UnsafeMutablePointer<T>
   private var bufferList: UnsafeMutablePointer<MediaBuffer<T>>

   // MARK: -

   public convenience init() {
      self.init(numberOfBuffers: 0, numberOfElements: 0)
   }

   public init(numberOfBuffers: Int, numberOfElements: Int) {
      self.numberOfBuffers = numberOfBuffers
      self.numberOfElements = numberOfElements
      maxNumberOfElements = Int(Double(numberOfElements) * 1.5) // Reserving capacity.
      let capacity = maxNumberOfElements * numberOfBuffers
      buffer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
      buffer.initialize(repeating: T(), count: capacity)
      bufferList = UnsafeMutablePointer<MediaBuffer<T>>.allocate(capacity: numberOfBuffers)
      updateBufferList()
   }

   private init(other: MediaBufferCollection) {
      numberOfBuffers = other.numberOfBuffers
      numberOfElements = other.numberOfElements
      maxNumberOfElements = other.maxNumberOfElements
      let capacity = maxNumberOfElements * numberOfBuffers
      buffer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
      buffer.initialize(from: other.buffer, count: capacity)
      bufferList = UnsafeMutablePointer<MediaBuffer<T>>.allocate(capacity: other.numberOfBuffers)
      updateBufferList()
   }

   deinit {
      buffer.deinitialize(count: bufferLength)
      buffer.deallocate()

      bufferList.deinitialize(count: numberOfBuffers)
      bufferList.deallocate()

      numberOfBuffers = 0
      numberOfElements = 0
   }
}

// MARK: - Public

extension MediaBufferCollection {

   public var mediaBufferList: MediaBufferList<T> {
      return MediaBufferList(mutableBuffers: bufferList, numberOfBuffers: numberOfBuffers)
   }

   public var isEmpty: Bool {
      return numberOfElements == 0
   }

   public func clone() -> MediaBufferCollection {
      return MediaBufferCollection(other: self)
   }

   public func erase() {
      buffer.initialize(repeating: T(), count: bufferLength)
   }

   public subscript(index: Int) -> MediaBuffer<T> {
      return element(at: index)
   }

   @discardableResult
   public func resize(numberOfElements: Int) -> Bool {
      if self.numberOfElements != numberOfElements {
         let result = reserveCapacity(newNumberOfElements: numberOfElements)
         self.numberOfElements = numberOfElements
         updateBufferList()
         return result
      }
      return false
   }

   @discardableResult
   public func resize(numberOfBuffers: Int) -> Bool {
      if self.numberOfBuffers != numberOfBuffers {
         let result = reserveCapacity(newNumberOfBuffers: numberOfBuffers)
         self.numberOfBuffers = numberOfBuffers
         updateBufferList()
         return result
      }
      return false
   }

   @discardableResult
   public func resize(numberOfBuffers: Int, numberOfElements: Int) -> Bool {
      var isUpdated = resize(numberOfBuffers: numberOfBuffers)
      isUpdated = resize(numberOfElements: numberOfElements) || isUpdated
      return isUpdated
   }

   @discardableResult
   public func reserveCapacity(numberOfElements: Int) -> Bool {
      if numberOfElements > self.numberOfElements {
         let result = reserveCapacity(newNumberOfElements: numberOfElements)
         updateBufferList()
         return result
      }
      return false
   }

   @discardableResult
   public func reserveCapacity(numberOfBuffers: Int) -> Bool {
      if numberOfBuffers > self.numberOfBuffers {
         let result = reserveCapacity(newNumberOfBuffers: numberOfBuffers)
         updateBufferList()
         return result
      }
      return false
   }

   @discardableResult
   public func reserveCapacity(numberOfBuffers: Int, numberOfElements: Int) -> Bool {
      var isUpdated = reserveCapacity(numberOfBuffers: numberOfBuffers)
      isUpdated = reserveCapacity(numberOfElements: numberOfElements) || isUpdated
      return isUpdated
   }
}

// MARK: - Private

extension MediaBufferCollection {

   var numberOfReservedElements: Int {
      return maxNumberOfElements - numberOfElements
   }

   private var bufferLength: Int {
      return maxNumberOfElements * numberOfBuffers
   }

   private func element(at index: Int) -> MediaBuffer<T> {
      precondition(index < numberOfBuffers)
      let bufferPointer = buffer.advanced(by: index * maxNumberOfElements)
      return MediaBuffer(mutableData: bufferPointer, numberOfElements: numberOfElements)
   }

   private func updateBufferList() {
      for index in 0 ..< numberOfBuffers {
         bufferList[index] = element(at: index)
      }
   }

   private func reserveCapacity(newNumberOfElements: Int) -> Bool {
      var isUpdated = false
      if newNumberOfElements > maxNumberOfElements {
         isUpdated = true
         let newMaxNumberOfElements = Int(Double(newNumberOfElements) * 1.5) // Reserving capacity.
         let capacity = numberOfBuffers * newMaxNumberOfElements
         let newBuffer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
         newBuffer.initialize(repeating: T(), count: capacity)
         for index in 0 ..< numberOfBuffers {
            let positionRead = buffer.advanced(by: index * maxNumberOfElements)
            let positionWrite = newBuffer.advanced(by: index * newMaxNumberOfElements)
            positionWrite.moveInitialize(from: positionRead, count: numberOfElements)
         }
         buffer.deallocate()
         buffer = newBuffer
         maxNumberOfElements = newMaxNumberOfElements
      } else if newNumberOfElements < numberOfElements {
         isUpdated = true
         let numberOfElementsToDeinitialize = numberOfElements - newNumberOfElements
         for index in 0 ..< numberOfBuffers {
            let position = buffer.advanced(by: index * numberOfElements + newNumberOfElements)
            position.deinitialize(count: numberOfElementsToDeinitialize)
         }
      }
      return isUpdated
   }

   private func reserveCapacity(newNumberOfBuffers: Int) -> Bool {

      var isUpdated = false

      // Buffer
      if newNumberOfBuffers > numberOfBuffers {
         isUpdated = true
         let capacity = newNumberOfBuffers * maxNumberOfElements
         let newBuffer = UnsafeMutablePointer<T>.allocate(capacity: capacity)
         newBuffer.initialize(repeating: T(), count: capacity)
         newBuffer.moveInitialize(from: buffer, count: bufferLength)
         buffer.deallocate()
         buffer = newBuffer
      } else if numberOfBuffers < newNumberOfBuffers {
         isUpdated = true
         let numberOfBuffersToDeinitialize = numberOfBuffers - newNumberOfBuffers
         let position = buffer.advanced(by: newNumberOfBuffers * maxNumberOfElements)
         position.deinitialize(count: numberOfBuffersToDeinitialize * maxNumberOfElements)
      }

      // BufferList
      if newNumberOfBuffers > numberOfBuffers {
         isUpdated = true
         let newBuffersList = UnsafeMutablePointer<MediaBuffer<T>>.allocate(capacity: newNumberOfBuffers)
         newBuffersList.moveInitialize(from: bufferList, count: numberOfBuffers)
         bufferList.deallocate()
         bufferList = newBuffersList
      } else if newNumberOfBuffers < numberOfBuffers {
         isUpdated = true
         let numberOfBuffersToDeinitialize = numberOfBuffers - newNumberOfBuffers
         bufferList.advanced(by: newNumberOfBuffers).deinitialize(count: numberOfBuffersToDeinitialize)
      }
      return isUpdated
   }
}

// MARK: - Debug

extension MediaBufferCollection {

   func dump() {
      for bufferIndex in 0 ..< numberOfBuffers {
         let channelBuffer = self[bufferIndex]
         var channelValues = "[\(bufferIndex)]:"
         for elementIndex in 0 ..< numberOfElements {
            channelValues += " \(channelBuffer[elementIndex])"
            channelValues += (elementIndex < numberOfElements - 1) ? "," : "."
         }
         print(channelValues)
      }
   }
}
