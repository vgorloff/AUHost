//
//  Dir.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class Dir {

   let path: String
   private let fm = FileManager.default

   init(path: String) {
      self.path = path
   }

   public var isExists: Bool {
      return fm.directoryExists(atPath: path)
   }

   public func contents() throws -> [String] {
      let contents = try fm.contentsOfDirectory(atPath: path)
      return contents.map { path.asPath.appendingComponent($0) }
   }

   public func directories() throws -> [String] {
      let allFiles = try contents()
      return allFiles.filter { fm.directoryExists(atPath: $0) }
   }

   public func files() throws -> [String] {
      let allFiles = try contents()
      return allFiles.filter { fm.regularFileExists(atPath: $0) }
   }
}
