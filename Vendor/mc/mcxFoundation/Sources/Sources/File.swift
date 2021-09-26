//
//  File.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxFoundationExtensions

public class File {

   public enum Error: Swift.Error {
      case unableToReadContents(String)
      case unableToWriteContents(String)
   }

   public let path: String
   private let manager = FileManager.default

   public init(path: String) {
      self.path = path
   }

   public func readLines(encoding: String.Encoding = .utf8) throws -> [String] {
      if let contents = manager.contents(atPath: path), let string = String(data: contents, encoding: encoding) {
         return string.componentsSeparatedByNewline
      } else {
         throw Error.unableToReadContents(path)
      }
   }

   public func writeLines(_ contents: [String], encoding: String.Encoding = .utf8) throws {
      if let data = contents.joined(separator: "\n").data(using: encoding) {
         manager.createFile(atPath: path, contents: data, attributes: nil)
      } else {
         throw Error.unableToWriteContents(path)
      }
   }

   public func mapLines(handler: ([String]) -> [String]) throws {
      let lines = try readLines()
      try writeLines(handler(lines))
   }
}
