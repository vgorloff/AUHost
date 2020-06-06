//
//  SuccessReporting.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public protocol SuccessReporting {
   func reportSuccess(message: String)
}

#if !os(macOS)
extension SuccessReporting where Self: UIViewController {

   public func reportSuccess(message: String) {
      // `title` needs to be empty string instead of `nil`. Otherwize `message` will be treated as `title`.
      let ac = UIAlertController(title: "", message: message, preferredStyle: .alert)
      let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      ac.addAction(cancelAction)
      present(ac, animated: true, completion: nil)
   }
}
#else
private struct FakeError: Swift.Error, LocalizedError, CustomStringConvertible {
   let description: String
   var errorDescription: String? {
      return description
   }
}

extension SuccessReporting where Self: NSViewController {
   public func reportSuccess(message: String) {
      presentError(FakeError(description: message))
   }
}
#endif
