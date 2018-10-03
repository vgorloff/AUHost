//
//  EdgeInsets.swift
//  mcFoundation
//
//  Created by Vlad Gorlov on 21.07.17.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
public typealias EdgeInsets = UIEdgeInsets
#elseif os(OSX)
import AppKit
public typealias EdgeInsets = NSEdgeInsets
#endif

public extension EdgeInsets {

   public init(left: CGFloat, right: CGFloat) {
      self.init(top: 0, left: left, bottom: 0, right: right)
   }

   public init(top: CGFloat, bottom: CGFloat) {
      self.init(top: top, left: 0, bottom: bottom, right: 0)
   }

   public init(horizontal: CGFloat, vertical: CGFloat) {
      self.init(top: vertical, left: horizontal, bottom: vertical, right: horizontal)
   }

   public init(horizontal: CGFloat) {
      self.init(top: 0, left: horizontal, bottom: 0, right: horizontal)
   }

   public init(vertical: CGFloat) {
      self.init(top: vertical, left: 0, bottom: vertical, right: 0)
   }

   init(dimension: CGFloat) {
      self.init(horizontal: dimension, vertical: dimension)
   }

   init(top: CGFloat) {
      self.init(top: top, left: 0, bottom: 0, right: 0)
   }

   init(bottom: CGFloat) {
      self.init(top: 0, left: 0, bottom: bottom, right: 0)
   }

   init(left: CGFloat) {
      self.init(top: 0, left: left, bottom: 0, right: 0)
   }

   init(right: CGFloat) {
      self.init(top: 0, left: 0, bottom: 0, right: right)
   }
}

public extension EdgeInsets {

   var vertical: CGFloat {
      return top + bottom
   }

   var horizontal: CGFloat {
      return left + right
   }
}
