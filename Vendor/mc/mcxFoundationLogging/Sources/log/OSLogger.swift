//
//  OSLogger.swift
//  Decode
//
//  Created by Vlad Gorlov on 01.01.21.
//

import Foundation
import mcxRuntime
import os.log

public class OSLogger: mcxRuntime.Logger {

   private var loggers = [Int: OSLog]()

   private func osLog(category: String) -> OSLog {
      let key = category.hashValue
      if let logger = loggers[key] {
         return logger
      } else {
         let logger = OSLog(subsystem: "com.mca." + Self.id, category: "com.mca." + category)
         loggers[key] = logger
         return logger
      }
   }

   override public func log(level: Level, message: String, category: String, dso: UnsafeRawPointer?) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let type: OSLogType
         switch level {
         case .verbose:
            type = .debug
         case .error:
            type = .error
         case .warn, .info:
            type = .info
         }
         let logger = osLog(category: category)
         os_log("%{public}@", dso: dso, log: logger, type: type, message)
      }
   }
}
