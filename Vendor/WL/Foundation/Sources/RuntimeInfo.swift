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
      public static let isPlaygroundTesting = "app.runtime.isPlaygroundTesting"
      public static let isUITesting = "app.runtime.isUITestingMode"
		public static let isLoggingEnabled = "app.runtime.isLoggingEnabled"
		public static let isTracingEnabled = "app.runtime.isTracingEnabled"
      public static let isNetworkTracingEnabled = "app.runtime.isNetworkTracingEnabled"
      public static let isInMemoryStore = "app.runtime.isInMemoryStore"
      public static let isStubsDisabled = "app.runtime.isStubsDisabled"
      public static let shouldAssertOnAmbiguousLayout = "app.runtime.shouldAssertOnAmbiguousLayout"
      public static let isReferenceTest = "app.runtime.isReferenceTest"
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
      return isUnderLogicTesting || isUITesting || isPlaygroundTesting
   }

   public static var isUnderLogicTesting: Bool = {
      NSClassFromString("XCTestCase") != nil
   }()

	public static let isUITesting: Bool = {
		isEnabled(variableName: Constants.isUITesting)
	}()

	public static let isInMemoryStore: Bool = {
		isEnabled(variableName: Constants.isInMemoryStore)
	}()

	public static let isPlaygroundTesting: Bool = {
		isEnabled(variableName: Constants.isPlaygroundTesting)
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

	public static let isStubsDisabled: Bool = {
		isEnabled(variableName: Constants.isStubsDisabled)
	}()

   public static let shouldAssertOnAmbiguousLayout: Bool = {
      isEnabled(variableName: Constants.shouldAssertOnAmbiguousLayout)
   }()

   public static let isReferenceTest: Bool = {
      isEnabled(variableName: Constants.isReferenceTest)
   }()

   public static let isLocalRun: Bool = {
      FileManager.default.regularFileExists(atPath: #file)
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

	private static func isEnabled(variableName: String, defaultValue: Bool = false) -> Bool {
		let variable = ProcessInfo.processInfo.environment[variableName]
		if let value = variable?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
			return value == "yes" || value == "true"
		} else {
			return defaultValue
		}
	}
}
