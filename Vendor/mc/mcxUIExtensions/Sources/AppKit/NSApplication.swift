//
//  MCANSApplication.swift
//  MenuBarApp
//
//  Created by Vlad Gorlov on 20.06.21.
//

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSApplication {
   public enum Dock {
   }
}

extension NSApplication.Dock {

   public enum MenuBarVisibiityRefreshMenthod: Int {
      case viaMenuVisibilityToggle, viaSystemAppActivation
   }

   public static func refreshMenuBarVisibiity(method: MenuBarVisibiityRefreshMenthod) {
      switch method {
      case .viaMenuVisibilityToggle:
         DispatchQueue.main.async { // Async call not reaaly needed. But intuition tells to leave it.
            // See: cocoa - Hiding the dock icon without hiding the menu bar - Stack Overflow: https://stackoverflow.com/questions/23313571/hiding-the-dock-icon-without-hiding-the-menu-bar
            NSMenu.setMenuBarVisible(false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Without delay windows were not always been brought to front.
               NSMenu.setMenuBarVisible(true)
               NSRunningApplication.current.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
            }
         }
      case .viaSystemAppActivation:
         DispatchQueue.main.async { // Async call not reaaly needed. But intuition tells to leave it.
            if let dockApp = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock").first {
               dockApp.activate(options: [])
            } else if let finderApp = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.finder").first {
               finderApp.activate(options: [])
            } else {
               assertionFailure("Neither Dock.app not Finder.app is found in system.")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // Without delay windows were not always been brought to front.
               NSRunningApplication.current.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
            }
         }
      }
   }

   public enum AppIconDockVisibilityUpdateMethod: Int {
      case carbon, appKit
   }

   @discardableResult
   public static func setAppIconVisibleInDock(_ shouldShow: Bool, method: AppIconDockVisibilityUpdateMethod = .appKit) -> Bool {
      switch method {
      case .appKit:
         return toggleDockIconViaAppKit(shouldShow: shouldShow)
      case .carbon:
         return toggleDockIconViaCarbon(shouldShow: shouldShow)
      }
   }

   private static func toggleDockIconViaCarbon(shouldShow state: Bool) -> Bool {
      // Get transform state.
      let transformState: ProcessApplicationTransformState
      if state {
         transformState = ProcessApplicationTransformState(kProcessTransformToForegroundApplication)
      } else {
         transformState = ProcessApplicationTransformState(kProcessTransformToUIElementApplication)
      }

      // Show / hide dock icon.
      var psn = ProcessSerialNumber(highLongOfPSN: 0, lowLongOfPSN: UInt32(kCurrentProcess))
      let transformStatus: OSStatus = TransformProcessType(&psn, transformState)
      return transformStatus == 0
   }

   private static func toggleDockIconViaAppKit(shouldShow state: Bool) -> Bool {
      let newPolicy: NSApplication.ActivationPolicy = state ? .regular : .accessory
      let result = NSApplication.shared.setActivationPolicy(newPolicy)
      return result
   }
}
#endif
