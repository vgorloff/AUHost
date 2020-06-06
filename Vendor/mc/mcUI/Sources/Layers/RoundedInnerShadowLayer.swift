//
//  RoundedInnerShadowLayer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.07.19.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

#if os(iOS) || os(tvOS)
public class RoundedInnerShadowLayer: CALayer {

   #if os(iOS) || os(tvOS)
   public typealias Color = UIColor
   public typealias BezierPath = UIBezierPath
   #elseif os(OSX)
   public typealias Color = NSColor
   public typealias BezierPath = NSBezierPath
   #endif

   override public var bounds: CGRect {
      didSet {
         update()
      }
   }

   override public init(layer: Any) {
      super.init(layer: layer)
   }

   public init(frame: CGRect = .zero, color: Color = .black, opacity: Float = 0.5,
               offset: CGSize = CGSize(width: 0, height: 0),
               blurRadius: CGFloat = 3, cornerRadius: CGFloat = 0) {
      super.init()

      masksToBounds = true
      self.cornerRadius = cornerRadius

      // Shadow properties
      shadowColor = color.cgColor
      shadowOffset = offset
      shadowOpacity = opacity
      shadowRadius = blurRadius

      self.frame = frame // Will call `update()` via setter.
   }

   private func update() {
      // Shadow path (1pt ring around bounds). Made by cutting off path.
      // See: https://stackoverflow.com/a/47791243/1418981
      let path = BezierPath(roundedRect: bounds.insetBy(dx: -2, dy: -2), cornerRadius: cornerRadius)
      let cutout = BezierPath(roundedRect: bounds, cornerRadius: cornerRadius).reversing()
      path.append(cutout)

      shadowPath = path.cgPath
   }

   required init?(coder: NSCoder) {
      fatalError()
   }
}
#endif
