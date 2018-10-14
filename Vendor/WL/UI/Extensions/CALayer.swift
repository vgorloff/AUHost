//
//  CALayer.swift
//  WLUI
//
//  Created by Vlad Gorlov on 18.11.17.
//  Copyright © 2017 Demo. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension CALayer {

   #if os(iOS) || os(tvOS)
   public typealias Color = UIColor
   public typealias RectEdge = UIRectEdge
   #elseif os(OSX)
   public typealias Color = NSColor
   public typealias RectEdge = NSRectEdge
   #endif

   public convenience init(backgroundColor: Color) {
      self.init()
      self.backgroundColor = backgroundColor.cgColor
   }

   public func bringToFront() {
      guard let sLayer = superlayer else {
         return
      }
      removeFromSuperlayer()
      sLayer.insertSublayer(self, at: UInt32(sLayer.sublayers?.count ?? 0))
   }

   public func sendToBack() {
      guard let sLayer = superlayer else {
         return
      }
      removeFromSuperlayer()
      sLayer.insertSublayer(self, at: 0)
   }

   #if os(iOS) || os(tvOS)
   public func addBorder(edge: RectEdge, color: Color, thickness: CGFloat) -> CALayer {

      let border = CALayer()

      switch edge {
      case RectEdge.top:
         border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
      case RectEdge.bottom:
         border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
      case RectEdge.left:
         border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
      case RectEdge.right:
         border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
      default:
         break
      }

      border.backgroundColor = color.cgColor
      addSublayer(border)

      return border
   }
   #endif
}
