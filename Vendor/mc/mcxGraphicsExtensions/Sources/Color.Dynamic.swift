//
//  Color.Dynamic.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

extension NSColor {

   public class func dynamicColor(light: NSColor, dark: NSColor) -> NSColor {
      if #available(OSX 10.15, *) {
         return NSColor(name: nil) {
            switch $0.name {
            case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
               return dark
            default:
               return light
            }
         }
      } else {
         return light
      }
   }
}
#endif

#if canImport(UIKit)
extension UIColor {

   public class func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
      if #available(iOS 13.0, *) {
         return UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
               return dark
            default:
               return light
            }
         }
      } else {
         return light
      }
   }

   @available(iOS 13.0, *)
   public func withAppearance(_ appearance: UIUserInterfaceStyle) -> UIColor {
      return resolvedColor(with: UITraitCollection(userInterfaceStyle: appearance))
   }
}
#endif
