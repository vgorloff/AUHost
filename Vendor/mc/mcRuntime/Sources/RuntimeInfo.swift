//
//  RuntimeInfo.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 02.04.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct RuntimeInfo {

   public struct Constants {

      public static let isBackdoorEnabled = "app.runtime.isBackdoorEnabled"
      public static let isLoggingEnabled = "app.runtime.isLoggingEnabled"
      public static let isTracingEnabled = "app.runtime.isTracingEnabled"
      public static let isNetworkTracingEnabled = "app.runtime.isNetworkTracingEnabled"
      public static let isInMemoryStore = "app.runtime.isInMemoryStore"
      public static let shouldAssertOnAmbiguousLayout = "app.runtime.shouldAssertOnAmbiguousLayout"
      public static let isPlaygroundTesting = "app.runtime.isPlaygroundTesting"
      public static let traceLogsDirPath = "app.runtime.traceLogsDirPath"
      public static let isAssertionsEnabled = "app.runtime.isAssertionsEnabled"
      public static let isLocalApi = "app.runtime.isLocalApi"
   }
}

extension RuntimeInfo {

   /**
    The raw system info string, e.g. "iPhone7,2".
    - SeeAlso: http://stackoverflow.com/a/30075200/1418981
    */
   public static var rawSystemInfo: String? {
      var systemInfo = utsname()
      uname(&systemInfo)
      return String(bytes: Data(bytes: &systemInfo.machine,
                                count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)
   }

   public static var isSimulator: Bool {
      return TARGET_OS_SIMULATOR != 0
   }

   public static var isUnderSwiftUIPreview: Bool {
        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] != nil
   }

   public static let isInsidePlayground = (Bundle.main.bundleIdentifier ?? "").hasPrefix("com.apple.dt")

   public static var isUnderTesting: Bool = {
      NSClassFromString("XCTestCase") != nil
   }()

   public static let isInMemoryStore: Bool = {
      isEnabled(variableName: Constants.isInMemoryStore)
   }()

   public static let isTracingEnabled: Bool = {
      isEnabled(variableName: Constants.isTracingEnabled)
   }()

   public static let isLoggingEnabled: Bool = {
      isEnabled(variableName: Constants.isLoggingEnabled, defaultValue: true)
   }()

   public static let isNetworkTracingEnabled: Bool = {
      isEnabled(variableName: Constants.isNetworkTracingEnabled)
   }()

   public static let shouldAssertOnAmbiguousLayout: Bool = {
      isEnabled(variableName: Constants.shouldAssertOnAmbiguousLayout)
   }()

   public static let isPlaygroundTesting: Bool = {
      isEnabled(variableName: Constants.isPlaygroundTesting)
   }()

   public static let isAssertionsEnabled: Bool = {
      isEnabled(variableName: Constants.isAssertionsEnabled)
   }()

   public static let isBackdoorEnabled: Bool = {
      isEnabled(variableName: Constants.isBackdoorEnabled)
   }()

   public static let isLocalApi: Bool = {
      isEnabled(variableName: Constants.isLocalApi)
   }()

   public static let isLocalRun: Bool = {
      var isDir = ObjCBool(false)
      let isExists = FileManager.default.fileExists(atPath: #file, isDirectory: &isDir)
      return isExists && !isDir.boolValue
   }()

   public static let traceLogsDirPath: String? = {
      ProcessInfo.processInfo.environment[Constants.traceLogsDirPath]
   }()

   #if os(iOS)
   public static let deviceName = UIDevice.current.name
   #elseif os(OSX)
   // This method executes synchronously. The execution time of this method can be highly variable,
   // depending on the local network configuration, and may block for several seconds if the network is unreachable.
   public static let serviceName = Host.current().name ?? "localhost"
   #endif
}

extension RuntimeInfo {

   public static func isEnabled(variableName: String, defaultValue: Bool = false) -> Bool {
      let variable = ProcessInfo.processInfo.environment[variableName]
      if let value = variable?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
         return value == "yes" || value == "true"
      } else {
         return defaultValue
      }
   }

   public static func stringValue(variableName: String) -> String? {
      let variable = ProcessInfo.processInfo.environment[variableName]
      return variable?.trimmingCharacters(in: .whitespacesAndNewlines)
   }
}
