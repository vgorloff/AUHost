//
//  MCAFileManager.swift
//  mcsCoreTests
//
//  Created by Vlad Gorlov on 02.05.21.
//

import Foundation

public class MCAFileManager {

   public let fileManager: FileManager

   public init(fileManager: FileManager = .default) {
      self.fileManager = fileManager
   }
}

extension MCAFileManager {

   public func contentsOfDirectory(atPath: String, predicate: NSPredicate) throws -> [String] {
      let files = try fileManager.contentsOfDirectory(atPath: atPath)
      return files.filter { predicate.evaluate(with: $0) }
   }

   public func contentsOfDirectory(atPath: String, passing test: (String) -> Bool) throws -> [String] {
      let files = try fileManager.contentsOfDirectory(atPath: atPath)
      return files.filter { test($0) }
   }

   public func recursiveContentsOfDirectory(atPath: String, shouldSkipDescendants: Bool = false,
                                            passing test: (String) -> Bool) -> [String] {
      guard let enumerator = fileManager.enumerator(atPath: atPath) else {
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
      guard let enumerator = fileManager.enumerator(atPath: atPath) else {
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

extension MCAFileManager {

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
      guard let enumerator = fileManager.enumerator(atPath: atPath) else {
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

extension MCAFileManager {

   public func directoryExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileManager.fileExists(atPath: path, isDirectory: &isDir)
      return isExists && isDir.boolValue
   }
}
