//
//  ArrayContainer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public final class ArrayContainer<Element> {
   public enum Event {
      case added(Int)
      case removed(Int)
   }

   private var elements: [Element] = []
   private let observers = ObserversContainer<Event>()

   public init(array: [Element]) {
      elements = array
   }
}

extension ArrayContainer {
   public func addObserver(on queue: DispatchQueue?, handler: @escaping (Event) -> Void) -> Disposable {
      return observers.addObserver(on: queue, handler)
   }
}

extension ArrayContainer {
   private func send(event: Event) {
      observers.fire(event)
   }
}

extension ArrayContainer: ExpressibleByArrayLiteral {
   public var isEmpty: Bool { return elements.isEmpty }
   public var count: Int { return elements.count }
   public var items: [Element] { return elements }

   public convenience init(arrayLiteral elements: Element...) {
      self.init(array: elements)
   }

   public subscript(index: Int) -> Element {
      return elements[index]
   }
}

extension ArrayContainer {
   public func append(_ element: Element) {
      let index = elements.count
      elements.append(element)
      send(event: .added(index))
   }

   public func remove(at index: Int) {
      guard elements.indices.contains(index) else {
         return
      }

      elements.remove(at: index)
      send(event: .removed(index))
   }

   public func removeLast() {
      let index = elements.count - 1
      remove(at: index)
   }
}
