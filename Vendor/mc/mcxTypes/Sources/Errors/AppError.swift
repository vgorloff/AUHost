//
//  AppError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxRuntime

public class AppError<T>: Swift.Error, LocalizedError, CustomStringConvertible {

   public let file: StaticString
   public let line: Int
   public let type: T

   public init(_ type: T, file: StaticString = #file, line: Int = #line) {
      self.type = type
      self.file = file
      self.line = line
   }

   public var description: String {

      let msg = String(describing: type)

      var components: [String] = []
      components.append(msg)

      var filePath = "\(file)"
      if let srcRootDirectory = BuildInfo.srcRootDirectory {
         filePath = filePath.replacingOccurrences(of: srcRootDirectory + "/", with: "")
      } else if !BuildInfo.isDebug {
         filePath = (filePath as NSString).lastPathComponent
      }
      components.append("Source: \(filePath):\(line)")

      let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
      let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
      if let appVersion = appVersion, let buildVersion = buildVersion {
         components.append("App version: \(appVersion)x\(buildVersion)")
      }

      return components.joined(separator: "\n")
   }
}
