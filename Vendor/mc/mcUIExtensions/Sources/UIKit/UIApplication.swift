//
//  UIApplication.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcFoundationObservables
import UIKit

#if NS_EXTENSION_UNAVAILABLE_IOS
public extension UIApplication {
   static func sharedApplicationDelegate<T>() -> T {
      guard let d = UIApplication.sharedApplication().delegate as? T else {
         fatalError()
      }
      return d
   }
}
#endif

extension UIApplication {

   public func takeMainWindowScreenshot() -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, false, 0)
      windows.forEach {
         if $0.screen == UIScreen.main {
            $0.drawHierarchy(in: $0.bounds, afterScreenUpdates: true)
         }
      }
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      if let image = image {
         log.debug(.app, "Captured screenshot image with size \(image.size).")
      }
      return image
   }
}

extension UIApplication {

   private static let telephoneScheme = "tel://"
   private static let telephonePromptScheme = "telprompt://"

   public static var canPlacePhoneCalls: Bool {
      guard let url = URL(string: telephoneScheme) else {
         return false
      }
      return shared.canOpenURL(url)
   }

   public static func call(phoneNumber: String, isPromptNeeded: Bool, completion: ((Bool) -> Void)? = nil) {
      let scheme = isPromptNeeded ? telephonePromptScheme : telephoneScheme
      let number = phoneNumber.components(separatedBy: CharacterSet.whitespacesAndNewlines).joined()
      guard let url = URL(string: scheme + number) else {
         return
      }
      shared.open(url, completionHandler: completion)
   }
}

@available(tvOS, unavailable)
extension UIApplication {

   public var statusBarDimension: CGFloat {
      let statusBarSize = statusBarFrame.size
      return Swift.min(statusBarSize.width, statusBarSize.height)
   }
}

#endif
