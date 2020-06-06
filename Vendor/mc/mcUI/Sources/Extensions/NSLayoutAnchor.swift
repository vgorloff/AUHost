//
//  NSLayoutAnchor.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension NSLayoutAnchor {

   @objc public func constraints(equalTo anchors: [NSLayoutAnchor<AnchorType>]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      for anchor in anchors {
         // Using `map` will not work here due compiler bug: https://stackoverflow.com/q/41700331/1418981
         let constraint = self.constraint(equalTo: anchor)
         constraints.append(constraint)
      }
      return constraints
   }

   @objc public func constraints(greaterThanOrEqualTo anchors: [NSLayoutAnchor<AnchorType>]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      for anchor in anchors {
         // Using `map` will not work here due compiler bug: https://stackoverflow.com/q/41700331/1418981
         let constraint = self.constraint(greaterThanOrEqualTo: anchor)
         constraints.append(constraint)
      }
      return constraints
   }
}
