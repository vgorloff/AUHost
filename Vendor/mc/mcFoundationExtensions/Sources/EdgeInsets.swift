//
//  EdgeInsets.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 21.07.17.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
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

extension EdgeInsets {

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

   public init(vertical: CGFloat, left: CGFloat, right: CGFloat) {
      self.init(top: vertical, left: left, bottom: vertical, right: right)
   }

   public init(dimension: CGFloat) {
      self.init(horizontal: dimension, vertical: dimension)
   }

   public init(top: CGFloat) {
      self.init(top: top, left: 0, bottom: 0, right: 0)
   }

   public init(bottom: CGFloat) {
      self.init(top: 0, left: 0, bottom: bottom, right: 0)
   }

   public init(left: CGFloat) {
      self.init(top: 0, left: left, bottom: 0, right: 0)
   }

   public init(right: CGFloat) {
      self.init(top: 0, left: 0, bottom: 0, right: right)
   }
}

extension EdgeInsets {

   public var vertical: CGFloat {
      return top + bottom
   }

   public var horizontal: CGFloat {
      return left + right
   }
}
