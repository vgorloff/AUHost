//
//  UnsafeCollection.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 19.03.16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

private extension Collection {
   var numberOfElementsInCollection: Int {
      var result = 0
      forEach { _ in result += 1 }
      return result
   }
}

/// - SeeAlso: http://stackoverflow.com/questions/27715985/secure-memory-for-swift-objects
public final class UnsafeCollection<T> {
   fileprivate var _collectionLength: Int = 0
   fileprivate var _bufferLength: Int = 0
   fileprivate var _buffer: UnsafeMutablePointer<T>!

   public func removeAll(keepCapacity: Bool = false) {
      _buffer.deinitialize(count: _collectionLength)
      _collectionLength = 0
      if !keepCapacity {
         _buffer.deallocate()
         _bufferLength = 0
         _buffer = nil
      }
   }

   public init() {
      _buffer = UnsafeMutablePointer<T>.allocate(capacity: 0)
   }

   deinit {
      removeAll()
   }
}

extension UnsafeCollection: CustomReflectable {
   public var customMirror: Mirror {
      let children = KeyValuePairs<String, Any>(dictionaryLiteral: ("buffer", _buffer as Any),
                                                ("bufferLength", _bufferLength),
                                                ("collectionLength", _collectionLength))
      return Mirror(self, children: children)
   }
}

extension UnsafeCollection: MutableCollection {

   public typealias IndexType = Int
   public typealias IteratorType = IndexingIterator<UnsafeCollection>

   // MARK: - Required implementations

   public func index(after i: IndexType) -> IndexType {
      return i + 1
   }

   public var startIndex: IndexType {
      return 0
   }

   public var endIndex: IndexType {
      return _collectionLength
   }

   public subscript(idx: IndexType) -> T {
      get {
         precondition(idx < _collectionLength)
         return _buffer[idx]
      }
      set(newElement) {
         precondition(idx < _collectionLength)
         let ptr = _buffer.advanced(by: idx)
         ptr.deinitialize(count: 1)
         ptr.initialize(to: newElement)
      }
   }

   // MARK: -

   public convenience init<C: Collection>(_ c: C) where C.Iterator.Element == IteratorType.Element {
      self.init()
      let sourceCollectionLength = c.numberOfElementsInCollection
      _buffer = UnsafeMutablePointer<T>.allocate(capacity: sourceCollectionLength)
      let bufferPointer = UnsafeMutableBufferPointer(start: _buffer, count: sourceCollectionLength)
      _ = bufferPointer.initialize(from: c)
      _collectionLength = sourceCollectionLength
      _bufferLength = sourceCollectionLength
   }
}

extension UnsafeCollection: RangeReplaceableCollection {

   // MARK: - Required implementations

   public func replaceSubrange<C>(_ subRange: Range<Int>, with newElements: C) where C: Collection, C.Iterator.Element == T {
      let newElementsLength = newElements.numberOfElementsInCollection
      let lengthDelta = newElementsLength - subRange.count
      let newCollectionLength = _collectionLength + lengthDelta
      reserveCapacity(newCollectionLength)

      let indexAtE2 = subRange.lowerBound + newElementsLength
      let bufferAtE1 = _buffer.advanced(by: subRange.upperBound)
      let bufferAtE2 = _buffer.advanced(by: indexAtE2)
      let numElementsToMove = newCollectionLength - indexAtE2

      if lengthDelta > 0 {
         // |----[S1]--[E1]----|
         // |----[S2]****[E2]----|
         // Where:
         // S1 = S2 = subRange.startIndex
         // E1 = subRange.endIndex
         // E2 = S2 + sourceCollectionLength
         bufferAtE2.moveInitialize(from: bufferAtE1, count: numElementsToMove)
      } else if lengthDelta < 0 {
         // |----[S1]----[E1]----|
         // |----[S2]**[E2]----|
         bufferAtE2.moveInitialize(from: bufferAtE1, count: numElementsToMove)
      } else {
         // |----[S1]----[E1]----|
         // |----[S2]****[E2]----|
      }
      let bufferAtS2 = _buffer.advanced(by: subRange.lowerBound)
      let bufferAtS2Pointer = UnsafeMutableBufferPointer(start: bufferAtS2, count: newElementsLength)
      _ = bufferAtS2Pointer.initialize(from: newElements)

      _collectionLength = newCollectionLength
   }

   // MARK: - Optional implementations

   public func reserveCapacity(_ n: Int) {
      if n > _bufferLength {
         let newBuf = UnsafeMutablePointer<T>.allocate(capacity: n)
         newBuf.moveInitialize(from: _buffer, count: _collectionLength)
         _buffer.deallocate()
         _buffer = newBuf
         _bufferLength = n
      }
   }

   public func append(_ x: T) {
      if _collectionLength == _bufferLength {
         reserveCapacity(Int(Double(_collectionLength) * 1.6) + 1)
      }
      _buffer.advanced(by: _collectionLength).initialize(to: x)
      _collectionLength += 1
   }

   // MARK: -

   public convenience init(capacity: Int) {
      self.init()
      reserveCapacity(capacity)
   }
}
