//
//  CALayer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 18.11.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension CALayer {

   #if os(iOS) || os(tvOS)
   public typealias Color = UIColor
   #elseif os(OSX)
   public typealias Color = NSColor
   #endif

   public convenience init(backgroundColor: Color) {
      self.init()
      self.backgroundColor = backgroundColor.cgColor
   }

   public func removeSublayers() {
      guard let sublayers = sublayers else { return }
      for sublayer in sublayers {
         sublayer.removeFromSuperlayer()
      }
   }

   public func removeSublayer(by name: String) {
      guard let sublayers = sublayers else { return }

      for sublayer in sublayers where sublayer.name == name {
         sublayer.removeFromSuperlayer()
      }
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

   public func setShadow(radius: CGFloat, opacity: Float = 0.3, color: Color? = nil, offset: CGSize? = nil) {
      shadowColor = (color ?? Color.black).cgColor
      if let offset = offset {
         shadowOffset = offset
      }
      shadowRadius = radius
      shadowOpacity = opacity
   }

   public func setBorder(width: CGFloat, color: Color? = nil) {
      borderWidth = width
      borderColor = color?.cgColor
   }

   public func setCornerRadius(_ radius: CGFloat) {
      masksToBounds = radius > 0
      cornerRadius = radius
   }

   public var animations: [CAAnimation] {
      guard let keys = animationKeys() else {
         return []
      }
      let anmations = keys.compactMap { animation(forKey: $0) }
      return anmations
   }
}
