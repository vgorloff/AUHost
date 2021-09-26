//
//  Process.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

#if os(macOS)

extension Process {

   public enum Error: Swift.Error {
      case unexpectedTerminationStatus(Int32, StaticString, Int)
      case unexpectedExitCode(ExitCode)
      case unableToConvertToDesiredType(Any.Type)
   }

   public static func findExecutablePath(_ executableName: String, isLoginShell: Bool = true) throws -> String {
      var args: [String] = []
      if isLoginShell {
         args += ["-l"]
      }
      args += ["-c", "which \(executableName)"]
      let task = Process(launchPath: "/bin/bash", arguments: args)
      return try task.launchAndReadOutputUntilExit()
   }

   public convenience init(name: String, arguments: [String]) {
      self.init()
      launchPath = "/usr/bin/env"
      self.arguments = [name] + arguments
   }

   @available(swift, deprecated: 5.1, renamed: "Process(name:arguments:)")
   public convenience init(executableName: String, arguments: [String]) {
      self.init(name: executableName, arguments: arguments)
   }

   public convenience init(executableName: String, arguments: String) {
      self.init()
      launchPath = "/usr/bin/env"
      self.arguments = [executableName] + parseArguments(arguments)
   }

   public convenience init(launchPath: String) {
      self.init()
      self.launchPath = launchPath
   }

   public convenience init(launchPath: String, arguments: [String]) {
      self.init()
      self.launchPath = launchPath
      self.arguments = arguments
   }

   @discardableResult
   public func launchAndWaitUntilExit() -> Int32 {
      launch()
      waitUntilExit()
      return terminationStatus
   }

   @available(swift, deprecated: 5.1, renamed: "asThrowing.run()")
   public func launchThrowingAndWaitUntilExit() throws {
      try asThrowing.run()
   }

   @discardableResult
   public func launchAndWaitExitCode() -> ExitCode {
      launch()
      waitUntilExit()
      return ExitCode(status: terminationStatus)
   }

   public var shellCommand: String {
      var values: [String] = []
      if let launchPath = launchPath {
         values.append(launchPath)
      }
      for argument in arguments ?? [] {
         if argument.contains(" ") {
            values.append("\"\(argument)\"")
         } else {
            values.append(argument)
         }
      }
      return values.joined(separator: " ")
   }
}

extension Process {

   @discardableResult
   public func launchAndWaitUntilExit(standardOutput out: inout Data) -> Int32 {
      let outPipe = Pipe()
      var outData = Data()
      outPipe.fileHandleForReading.readabilityHandler = {
         outData.append($0.availableData)
      }
      standardOutput = outPipe
      let status = launchAndWaitUntilExit()
      outPipe.fileHandleForReading.readabilityHandler = nil
      out = outData
      return status
   }

   @discardableResult
   public func launchAndWaitUntilExit(standardOutput out: inout String?) -> Int32 {
      var outData = Data()
      let status = launchAndWaitUntilExit(standardOutput: &outData)
      if !outData.isEmpty {
         out = String(data: outData, encoding: .utf8)
      } else {
         out = nil
      }
      return status
   }

   public func launchAndReadOutputDataUntilExit() throws -> Data {
      var outData = Data()
      let status = launchAndWaitUntilExit(standardOutput: &outData)
      if status != 0 {
         throw Error.unexpectedTerminationStatus(status, #file, #line)
      }
      return outData
   }

   public func launchAndReadOutputUntilExit(shouldStip: Bool = true) throws -> String {
      var result: String?
      let status = launchAndWaitUntilExit(standardOutput: &result)
      if status != 0 {
         throw Error.unexpectedTerminationStatus(status, #file, #line)
      } else {
         result = result?.trimmingCharacters(in: .whitespacesAndNewlines)
         return result ?? ""
      }
   }

   public func launchAndReadPlistUntilExit() throws -> [AnyHashable: Any] {
      var outData = Data()
      let status = launchAndWaitUntilExit(standardOutput: &outData)
      if status != 0 {
         throw Error.unexpectedTerminationStatus(status, #file, #line)
      } else {
         if let pl = try PropertyListSerialization.propertyList(from: outData, options: [], format: nil) as? [AnyHashable: Any] {
            return pl
         } else {
            throw Error.unableToConvertToDesiredType([AnyHashable: Any].self)
         }
      }
   }

   public func launchAndReadJSONUntilExit() throws -> [AnyHashable: Any] {
      return try asJson.object()
   }

   public func launchAndReadLinesUntilExit() throws -> [String] {
      let result = try launchAndReadOutputUntilExit()
      let components = result.components(separatedBy: CharacterSet.newlines)
      return components
   }

   public var asJson: ProcessAsJSON {
      return ProcessAsJSON(process: self)
   }

   public var asThrowing: ProcessAsThrowing {
      return ProcessAsThrowing(process: self)
   }
}

extension Process {

   func parseArguments(_ arguments: String) -> [String] {
      let arguments = arguments.trimmingCharacters(in: .whitespacesAndNewlines)
      if arguments.isEmpty {
         return []
      }
      func hasPrefix(_ arg: String) -> Bool {
         return arg.hasPrefix("\"") || arg.hasPrefix("'")
      }
      func hasSuffix(_ arg: String) -> Bool {
         return arg.hasSuffix("\"") || arg.hasSuffix("'")
      }
      var result: [String] = []
      var partialArgument: String?
      for arg in arguments.componentsSeparatedByWhitespace {
         if hasPrefix(arg), hasSuffix(arg) {
            let lowerBound = arg.index(after: arg.startIndex)
            let upperBound = arg.index(before: arg.endIndex)
            result.append(String(arg[lowerBound ..< upperBound]))
         } else if hasPrefix(arg) {
            let lowerBound = arg.index(after: arg.startIndex)
            partialArgument = String(arg[lowerBound ..< arg.endIndex]) + " "
         } else if hasSuffix(arg) {
            let upperBound = arg.index(before: arg.endIndex)
            result.append((partialArgument ?? "") + String(arg[arg.startIndex ..< upperBound]))
            partialArgument = nil
         } else {
            result.append(arg)
         }
      }
      return result
   }
}

public struct ProcessAsJSON {

   let process: Process

   init(process: Process) {
      self.process = process
   }

   public func object() throws -> [AnyHashable: Any] {
      var outData = Data()
      let status = process.launchAndWaitUntilExit(standardOutput: &outData)
      if status != 0 {
         throw Process.Error.unexpectedTerminationStatus(status, #file, #line)
      } else {
         if let pl = try JSONSerialization.jsonObject(with: outData, options: []) as? [AnyHashable: Any] {
            return pl
         } else {
            throw Process.Error.unableToConvertToDesiredType([AnyHashable: Any].self)
         }
      }
   }

   public func array() throws -> [[AnyHashable: Any]] {
      var outData = Data()
      let status = process.launchAndWaitUntilExit(standardOutput: &outData)
      if status != 0 {
         throw Process.Error.unexpectedTerminationStatus(status, #file, #line)
      } else {
         if let pl = try JSONSerialization.jsonObject(with: outData, options: []) as? [[AnyHashable: Any]] {
            return pl
         } else {
            throw Process.Error.unableToConvertToDesiredType([AnyHashable: Any].self)
         }
      }
   }
}

public struct ProcessAsThrowing {

   let process: Process

   init(process: Process) {
      self.process = process
   }

   public func run() throws {
      // process.run() // New API.
      process.launch()
      process.waitUntilExit()
      if process.terminationStatus != 0 {
         throw Process.Error.unexpectedTerminationStatus(process.terminationStatus, #file, #line)
      }
   }
}

#endif
