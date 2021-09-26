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
      return try MCAFileManager(fileManager: self).contentsOfDirectory(atPath: atPath, predicate: predicate)
   }

   public func contentsOfDirectory(atPath: String, passing test: (String) -> Bool) throws -> [String] {
      return try MCAFileManager(fileManager: self).contentsOfDirectory(atPath: atPath, passing: test)
   }

   public func recursiveContentsOfDirectory(atPath: String, shouldSkipDescendants: Bool = false,
                                            passing test: (String) -> Bool) -> [String] {
      return MCAFileManager(fileManager: self).recursiveContentsOfDirectory(atPath: atPath,
                                                                            shouldSkipDescendants: shouldSkipDescendants,
                                                                            passing: test)
   }

   public func recursiveContentsOfDirectory(atPath: String, shouldSkipDescendants: Bool = false,
                                            predicate: NSPredicate? = nil) -> [String] {
      return MCAFileManager(fileManager: self).recursiveContentsOfDirectory(atPath: atPath,
                                                                            shouldSkipDescendants: shouldSkipDescendants,
                                                                            predicate: predicate)
   }

   public func recursiveContentsOfDirectory(atPath: String, passing test: (String) -> MCAFileManager.Status) -> [String] {
      return MCAFileManager(fileManager: self).recursiveContentsOfDirectory(atPath: atPath, passing: test)
   }
}
