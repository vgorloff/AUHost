//
//  NSLayoutYAxisAnchor.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

#if os(iOS) || os(tvOS)
extension NSLayoutYAxisAnchor {

   @available(iOS 11.0, tvOS 11.0, *)
   public func constraintEqualToSystemSpacingBelow(_ anchor: NSLayoutYAxisAnchor) -> NSLayoutConstraint {
      return constraint(equalToSystemSpacingBelow: anchor, multiplier: 1)
   }
}
#endif
