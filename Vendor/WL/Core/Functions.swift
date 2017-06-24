//
//  Functions.swift
//  WaveLabs
//
//  Created by Volodymyr Gorlov on 25.11.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public struct g { // swiftlint:disable:this type_name
}

public struct a { // swiftlint:disable:this type_name
}

public struct c { // swiftlint:disable:this type_name
}

extension a {
	public static func map<A, B>(arg: A?, closure: (A) -> B) -> B? {
		if let value = arg {
			return closure(value)
		}
		return nil
	}
}

extension g {

   public static func configure<T>(_ element: T, _ closure: (T) -> Void) -> T {
      closure(element)
      return element
   }

   public static func configureEach<T>(_ elements: [T], _ closure: (T) -> Void) {
      elements.forEach { closure($0) }
   }

}

// MARK: - Global

extension g {
   /// - parameter object: Object instance.
   /// - returns: Object address pointer as Int.
   /// - SeeAlso: [ Printing a variable memory address in swift - Stack Overflow ]
   ///            (http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
   public static func pointerAddress(of object: AnyObject) -> Int {
      return unsafeBitCast(object, to: Int.self)
   }

   /// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
   public static func noop() {
   }

   /// - returns: Time interval in seconds.
   /// - parameter closure: Code block to measure performance.
   public static func benchmark(_ closure: () -> Void) -> CFTimeInterval {
      let startTime = CFAbsoluteTimeGetCurrent()
      closure()
      return CFAbsoluteTimeGetCurrent() - startTime
   }

   public static func string(fromClass cls: AnyClass) -> String {
      return NSStringFromClass(cls)
   }

}

public protocol MergeableType {
   func compare(with: Self) -> ComparisonResult
   mutating func mergeIfNeeded(with: Self) -> Bool
}

extension c {

   public static func merge<T: MergeableType>(_ existing: [T], with newElements: inout [T]) -> [T] {
      var insertedOrUpdated = [T]()
      var processed = [T]()

      var iteratorEx = existing.makeIterator()
      var iteratorNew = newElements.makeIterator()
      var entityOrNilEx = iteratorEx.next()
      var entityOrNilNew = iteratorNew.next()
      repeat {
         guard var entityEx = entityOrNilEx, let entityNew = entityOrNilNew else {
            break
         }
         let result = entityEx.compare(with: entityNew)
         switch result {
         case .orderedAscending:
            entityOrNilEx = iteratorEx.next()
         case .orderedDescending:
            entityOrNilNew = iteratorNew.next()
            insertedOrUpdated.append(entityNew)
         case .orderedSame:
            processed.append(entityNew)
            if entityEx.mergeIfNeeded(with: entityNew) {
               insertedOrUpdated.append(entityEx)
            }
            entityOrNilEx = iteratorEx.next()
            entityOrNilNew = iteratorNew.next()
         }

      } while (true)

      // Continue inserting if there are still available new entries from server
      while let entityNew = entityOrNilNew {
         insertedOrUpdated.append(entityNew)
         entityOrNilNew = iteratorNew.next()
      }
      newElements = processed

      return insertedOrUpdated
   }
}
