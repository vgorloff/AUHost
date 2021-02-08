//
//  Functions.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

// See: https://stackoverflow.com/a/56836695/1418981
public func isDebuggerAttached() -> Bool {
   var debuggerIsAttached = false

   var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
   var info: kinfo_proc = kinfo_proc()
   var info_size = MemoryLayout<kinfo_proc>.size

   let success = name.withUnsafeMutableBytes { (nameBytePtr: UnsafeMutableRawBufferPointer) -> Bool in
      guard let nameBytesBlindMemory = nameBytePtr.bindMemory(to: Int32.self).baseAddress else {
         return false
      }
      let status = sysctl(nameBytesBlindMemory, 4, &info/*UnsafeMutableRawPointer!*/, &info_size/*UnsafeMutablePointer<Int>!*/, nil, 0)
      return -1 != status
   }

   // The original HockeyApp code checks for this; you could just as well remove these lines:
   if !success {
      debuggerIsAttached = false
   }

   if !debuggerIsAttached && (info.kp_proc.p_flag & P_TRACED) != 0 {
      debuggerIsAttached = true
   }

   return debuggerIsAttached
}

@discardableResult
public func configure<T>(_ element: T, _ closure: (T) -> Void) -> T {
   closure(element)
   return element
}

/// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
public func noop() {
}

/// Function for debug purpose which does nothing, but not stripped by compiler during optimization.
public func noop(_: Any) {
}

/// - parameter object: Object instance.
/// - returns: Object address pointer as Int.
/// - SeeAlso: [ Printing a variable memory address in swift - Stack Overflow ]
///            (http://stackoverflow.com/questions/24058906/printing-a-variable-memory-address-in-swift)
public func pointerAddress(of object: AnyObject) -> Int {
   return unsafeBitCast(object, to: Int.self)
}

#if os(macOS)
import AppKit
public func AppMain(_ principalClass: NSApplication.Type) {
   autoreleasepool {
      // Even if we loading application manually we need to setup `Info.plist` key:
      // <key>NSPrincipalClass</key>
      // <string>NSApplication</string>
      // Otherwise Application will be loaded in `low resolution` mode.
      let app = principalClass.shared
      app.setActivationPolicy(.regular)
      app.run()
   }
}
#else
import UIKit
public func AppMain(_ principalClass: UIApplication.Type) {
   UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(principalClass), nil)
}
#endif
