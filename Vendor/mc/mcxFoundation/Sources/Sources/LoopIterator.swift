//
//  LoopIterator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 16.07.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct LoopIterator<Base: Collection>: IteratorProtocol {

   private let collection: Base
   private var index: Base.Index

   public init(collection: Base) {
      self.collection = collection
      index = collection.startIndex
   }

   public mutating func next() -> Base.Iterator.Element? {
      guard !collection.isEmpty else {
         return nil
      }

      let result = collection[index]
      collection.formIndex(after: &index) // (*) See discussion below
      if index == collection.endIndex {
         index = collection.startIndex
      }
      return result
   }
}

extension Array {

   public func makeLoopIterator() -> LoopIterator<Array> {
      return LoopIterator(collection: self)
   }
}
