//
//  OperationQueue.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 23.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public extension OperationQueue {
   
   public struct UserInteractive {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .userInteractive
         q.name = name
         return q
      }
   }
   
   public struct UserInitiated {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .userInitiated
         q.name = name
         return q
      }
   }
   
   public struct Utility {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .utility
         q.name = name
         return q
      }
   }
   
   public struct Background {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .background
         q.name = name
         return q
      }
   }
   
   public struct Default {
      public static func nonConcurrent(name: String? = nil) -> OperationQueue {
         let q = concurrent(name: name)
         q.maxConcurrentOperationCount = 1
         return q
      }
      public static func concurrent(name: String? = nil) -> OperationQueue {
         let q = OperationQueue()
         q.qualityOfService = .default
         q.name = name
         return q
      }
   }
   
   public struct NonConcurrent {
      public static func userInteractive(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInteractive.nonConcurrent(name: name)
      }
      public static func userInitiated(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInitiated.nonConcurrent(name: name)
      }
      public static func utility(name: String? = nil) -> OperationQueue {
         return OperationQueue.Utility.nonConcurrent(name: name)
      }
      public static func background(name: String? = nil) -> OperationQueue {
         return OperationQueue.Background.nonConcurrent(name: name)
      }
      public static func `default`(name: String? = nil) -> OperationQueue {
         return OperationQueue.Default.nonConcurrent(name: name)
      }
   }
   
   public struct Concurrent {
      public static func userInteractive(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInteractive.concurrent(name: name)
      }
      public static func userInitiated(name: String? = nil) -> OperationQueue {
         return OperationQueue.UserInitiated.concurrent(name: name)
      }
      public static func utility(name: String? = nil) -> OperationQueue {
         return OperationQueue.Utility.concurrent(name: name)
      }
      public static func background(name: String? = nil) -> OperationQueue {
         return OperationQueue.Background.concurrent(name: name)
      }
      public static func `default`(name: String? = nil) -> OperationQueue {
         return OperationQueue.Default.concurrent(name: name)
      }
   }
   
}
