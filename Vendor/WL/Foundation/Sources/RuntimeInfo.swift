//
//  RuntimeInfo.swift
//  mcCore
//
//  Created by Vlad Gorlov on 02.04.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct RuntimeInfo {

   public struct Constants {
      public static let isPlaygroundTestingMode = "app.runtime.isPlaygroundTestingMode"
      public static let isUITestingMode = "app.runtime.isUITestingMode"
      public static let isNetworkingTraceEnabled = "app.runtime.isNetworkingTraceEnabled"
      public static let isInMemoryStore = "app.runtime.isInMemoryStore"
      public static let isStubsDisabled = "app.runtime.isStubsDisabled"
      public static let shouldAssertOnAmbiguousLayout = "app.runtime.shouldAssertOnAmbiguousLayout"
   }

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

   public static let isInsidePlayground = (Bundle.main.bundleIdentifier ?? "").hasPrefix("com.apple.dt")

   public static var isUnderTesting: Bool {
      return isUnderLogicTesting || isUnderUITesting || isPlaygroundTesting
   }

   public static var isUnderLogicTesting: Bool = {
      NSClassFromString("XCTestCase") != nil
   }()

   public static let isUnderUITesting: Bool = {
      ProcessInfo.processInfo.environment[Constants.isUITestingMode] != nil
   }()

   public static let isInMemoryStore: Bool = {
      ProcessInfo.processInfo.environment[Constants.isInMemoryStore] != nil
   }()

   public static let isPlaygroundTesting: Bool = {
      ProcessInfo.processInfo.environment[Constants.isPlaygroundTestingMode] != nil
   }()

   public static let isNetworkingTraceEnabled: Bool = {
      ProcessInfo.processInfo.environment[Constants.isNetworkingTraceEnabled] != nil
   }()

   public static let isStubsDisabled: Bool = {
      ProcessInfo.processInfo.environment[Constants.isStubsDisabled] != nil
   }()

   public static let shouldAssertOnAmbiguousLayout: Bool = {
      ProcessInfo.processInfo.environment[Constants.shouldAssertOnAmbiguousLayout] != nil
   }()

   #if os(iOS)
   public static let deviceName = UIDevice.current.name
   #elseif os(OSX)
   // This method executes synchronously. The execution time of this method can be highly variable,
   // depending on the local network configuration, and may block for several seconds if the network is unreachable.
   public static let serviceName = Host.current().name ?? "localhost"
   #endif
}
