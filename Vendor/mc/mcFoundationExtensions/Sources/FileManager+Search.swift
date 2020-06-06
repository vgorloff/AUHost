//
//  FileManager+Search.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension FileManager {

   public func contentsOfDirectory(atPath: String, predicate: NSPredicate) throws -> [String] {
      let files = try contentsOfDirectory(atPath: atPath)
      return files.filter { predicate.evaluate(with: $0) }
   }

   public func contentsOfDirectory(atPath: String, passing test: (String) -> Bool) throws -> [String] {
      let files = try contentsOfDirectory(atPath: atPath)
      return files.filter { test($0) }
   }

   public func recursiveContentsOfDirectory(atPath: String, shouldSkipDescendants: Bool = false,
                                            passing test: (String) -> Bool) -> [String] {
      guard let enumerator = enumerator(atPath: atPath) else {
         return []
      }
      var results: [String] = []
      while let file = enumerator.nextObject() as? String {
         let isPassed = test(file)
         if isPassed {
            results.append(file)
         } else if shouldSkipDescendants {
            enumerator.skipDescendants()
         }
      }
      return results
   }

   public func recursiveContentsOfDirectory(atPath: String, shouldSkipDescendants: Bool = false,
                                            predicate: NSPredicate? = nil) -> [String] {
      guard let enumerator = enumerator(atPath: atPath) else {
         return []
      }
      var results = [String]()
      while let file = enumerator.nextObject() as? String {
         let isPassed = predicate?.evaluate(with: file) ?? true
         if isPassed {
            results.append(file)
         } else if shouldSkipDescendants {
            enumerator.skipDescendants()
         }
      }
      return results
   }
}

extension FileManager {

   public enum Status {
      case accept
      case reject
      case skipDescendants

      public init(_ status: Bool) {
         if status {
            self = .accept
         } else {
            self = .reject
         }
      }
   }

   public func recursiveContentsOfDirectory(atPath: String, passing test: (String) -> Status) -> [String] {
      guard let enumerator = enumerator(atPath: atPath) else {
         return []
      }
      var results: [String] = []
      while let file = enumerator.nextObject() as? String {
         let status = test(file)
         switch status {
         case .accept:
            results.append(file)
         case .reject:
            break
         case .skipDescendants:
            enumerator.skipDescendants()
         }
      }
      return results
   }
}
