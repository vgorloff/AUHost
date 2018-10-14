//
//  FailureReporting.swift
//  Carmudi
//
//  Created by VG (DE) on 19/12/2016.
//  Copyright © 2016 Carmudi GmbH. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public protocol FailureReporting {
   func reportFailure(error: Swift.Error)
}

extension FailureReporting {

   public func reportFailure(closure: () throws -> Void) {
      do {
         return try closure()
      } catch {
         reportFailure(error: error)
      }
   }
}
