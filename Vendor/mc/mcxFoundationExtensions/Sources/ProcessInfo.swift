//
//  ProcessInfo.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension ProcessInfo {

   public enum Variable: String {
      case PWD = "PWD"
      case HOME = "HOME"
      case TMPDIR = "TMPDIR"
   }

   public enum Error: Swift.Error {
      case unableToFindEnvironmentVariable(String, StaticString)
   }

   public var asEnvironment: ProcessInfoAsEnvironment {
      return ProcessInfoAsEnvironment(processInfo: self)
   }
}

extension ProcessInfo {

   public static var executableFilePath: String {
      return ProcessInfo.processInfo.arguments[0]
   }

   public static var executableFileName: String {
      return (executableFilePath as NSString).lastPathComponent
   }

   public static var executableDirectoryPath: String {
      return (executableFilePath as NSString).deletingLastPathComponent
   }
}

extension ProcessInfo {

   @available(swift, deprecated: 5.1, renamed: "asEnvironment.existingVariable()")
   public func existingEnvironmentVariable(_ name: String) throws -> String {
      try asEnvironment.existingVariable(name)
   }

   @available(swift, deprecated: 5.1, renamed: "asEnvironment.dump()")
   public func dumpEnvironment() {
      asEnvironment.dump()
   }

   @available(swift, deprecated: 5.1, renamed: "asEnvironment.variable()")
   public func environmentVariable(_ variable: Variable) -> String? {
      return asEnvironment.variable(variable)
   }

   @available(swift, deprecated: 5.1, renamed: "asEnvironment.existingVariable()")
   public func existingEnvironmentVariable(_ variable: Variable) throws -> String {
      return try asEnvironment.existingVariable(variable)
   }
}

public struct ProcessInfoAsEnvironment {

   let processInfo: ProcessInfo

   init(processInfo: ProcessInfo) {
      self.processInfo = processInfo
   }

   public func variable(_ name: String) -> String? {
      return processInfo.environment[name]
   }

   public func existingVariable(_ name: String) throws -> String {
      if let value = processInfo.environment[name] {
         return value
      } else {
         throw ProcessInfo.Error.unableToFindEnvironmentVariable(name, #file)
      }
   }

   public func variable(_ name: ProcessInfo.Variable) -> String? {
      return variable(name.rawValue)
   }

   public func existingVariable(_ name: ProcessInfo.Variable) throws -> String {
      return try existingVariable(name.rawValue)
   }

   public func dump() {
      let info = processInfo.environment.map { "\($0.key): \($0.value)" }
      print(info.joined(separator: "\n"))
   }
}
