//
//  AppNotification.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Foundation
import mcTypes

public class AppNotification {
   public typealias AppDidBecomeActive = AppDidBecomeActiveNotification
   public typealias AppWillEnterForeground = AppDidBecomeActiveNotification
}

public class AppDidBecomeActiveNotification: NotificationObserver {
   public init(object: Any? = nil, queue: OperationQueue = .main, handler: Handler? = nil) {
      let name: NSNotification.Name
      #if targetEnvironment(macCatalyst)
      // Workaround: Otherwize use method with Bundle: https://stackoverflow.com/a/58679398/1418981
      name = NSNotification.Name(rawValue: "NSApplicationDidBecomeActiveNotification")
      #elseif os(macOS)
      name = NSApplication.didBecomeActiveNotification
      #else
      name = UIApplication.didBecomeActiveNotification
      #endif
      super.init(name: name, object: object, queue: queue, handler: handler)
   }
}

public class AppWillEnterForegroundNotification: NotificationObserver {

   public init(object: Any? = nil, queue: OperationQueue = .main, handler: Handler? = nil) {
      let name: NSNotification.Name
      #if targetEnvironment(macCatalyst)
      // Workaround: Otherwize use method with Bundle: https://stackoverflow.com/a/58679398/1418981
      name = NSNotification.Name(rawValue: "NSApplicationWillBecomeActiveNotification")
      #elseif os(macOS)
      name = NSApplication.willBecomeActiveNotification
      #else
      name = UIApplication.willEnterForegroundNotification
      #endif
      super.init(name: name, object: object, queue: queue, handler: handler)
   }
}
