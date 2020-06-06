//
//  FailureReporting.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
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

   @available(swift, deprecated: 5.1, renamed: "tryReportingFailure()")
   public func reportFailure(closure: () throws -> Void) {
      do {
         return try closure()
      } catch {
         reportFailure(error: error)
      }
   }

   public func tryReportingFailure(closure: () throws -> Void) {
      do {
         return try closure()
      } catch {
         reportFailure(error: error)
      }
   }
}

#if !os(macOS)
extension FailureReporting where Self: UIViewController {

   public func reportFailure(error: Swift.Error) {
      log.error(.view, error)
      // `title` needs to be empty string instead of `nil`. Otherwize `message` will be treated as `title`.
      let ac = UIAlertController(title: "", message: String(describing: error), preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      ac.addAction(cancelAction)
      present(ac, animated: true)
   }
}
#else
extension FailureReporting where Self: NSViewController {
   public func reportFailure(error: Swift.Error) {
      log.error(.view, error)
      presentError(error)
   }
}
#endif
