//
//  MediaBuffer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.07.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

public struct MediaBuffer<T> {

   public let dataByteSize: Int
   public let data: UnsafePointer<T>
   public let mutableData: UnsafeMutablePointer<T>
   public let numberOfElements: Int

   public init(mutableData: UnsafeMutablePointer<T>, numberOfElements: Int) {
      self.numberOfElements = numberOfElements
      dataByteSize = MemoryLayout<T>.stride * numberOfElements
      self.mutableData = mutableData
      data = UnsafePointer(mutableData)
   }

   public init(data: UnsafePointer<T>, numberOfElements: Int) {
      self.numberOfElements = numberOfElements
      dataByteSize = MemoryLayout<T>.stride * numberOfElements
      mutableData = UnsafeMutablePointer(mutating: data)
      self.data = data
   }

   public subscript(index: Int) -> T {
      get {
         precondition(index < numberOfElements)
         return data[index]
      } set {
         precondition(index < numberOfElements)
         mutableData[index] = newValue
      }
   }

   public var bufferPointer: UnsafeMutableBufferPointer<T> {
      return UnsafeMutableBufferPointer<T>(start: mutableData, count: Int(numberOfElements))
   }
}
