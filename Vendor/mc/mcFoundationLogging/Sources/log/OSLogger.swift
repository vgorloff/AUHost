//
//  OSLogger.swift
//  Decode
//
//  Created by Vlad Gorlov on 01.01.21.
//

import Foundation
import os.log
import mcRuntime

public class OSLogger: mcRuntime.Logger {

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

   public override func log(level: Level, message: String, category: String, dso: UnsafeRawPointer?) {
      if #available(OSX 10.12, iOS 10.0, *) {
         let type: OSLogType
         switch level {
         case .debug, .verbose:
            type = .debug
         case .error:
            type = .error
         case .warning, .info:
            type = .info
         }
         let logger = osLog(category: category)
         os_log("%{public}@", dso: dso, log: logger, type: type, message)
      }
   }
}
