//
//  FileManager.swift
//  mcFoundation
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

extension FileManager {

   public static var documentsDirectory: URL {
      let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var applicationSupportDirectory: URL {
      let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var cachesDirectory: URL {
      let urls = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
      return urls[urls.count - 1]
   }

   public static var homeDirectory: String {
      return NSHomeDirectory()
   }
}

extension FileManager {

   public func regularFileExists(at url: URL) -> Bool {
      return regularFileExists(atPath: url.path)
   }

   public func directoryExists(at url: URL) -> Bool {
      return directoryExists(atPath: url.path)
   }

   public func directoryExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileExists(atPath: path, isDirectory: &isDir)
      return isExists && isDir.boolValue
   }

   public func regularFileExists(atPath path: String) -> Bool {
      var isDir = ObjCBool(false)
      let isExists = fileExists(atPath: path, isDirectory: &isDir)
      return isExists && !isDir.boolValue
   }

   public func createFile(atPath path: String, contents: Data?, withIntermediateDirectories: Bool) throws {
      let dirPath = (path as NSString).deletingLastPathComponent
      if !directoryExists(atPath: dirPath) {
         try createDirectory(atPath: dirPath, withIntermediateDirectories: withIntermediateDirectories)
      }
      createFile(atPath: path, contents: contents, attributes: nil)
   }

   public func copyFile(atPath: String, toPath: String) throws {
      let dirPath = toPath.deletingLastPathComponent
      if !directoryExists(atPath: dirPath) {
         try createDirectory(atPath: dirPath, withIntermediateDirectories: true)
      } else if fileExists(atPath: toPath) {
         try removeItem(atPath: toPath)
      }
      try copyItem(atPath: atPath, toPath: toPath)
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

   public func contentsOfDirectory(atPath: String, passing test: (String) -> Bool) throws -> [String] {
      let files = try contentsOfDirectory(atPath: atPath)
      return files.filter { test($0) }
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
