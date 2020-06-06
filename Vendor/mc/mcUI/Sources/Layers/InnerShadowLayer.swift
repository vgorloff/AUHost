//
//  InnerShadowLayer.swift
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
public class InnerShadowLayer: CALayer {

   #if os(iOS) || os(tvOS)
   public typealias Color = UIColor
   public typealias RectEdge = UIRectEdge
   #elseif os(OSX)
   public typealias Color = NSColor
   public typealias RectEdge = NSRectEdge
   #endif

   public let edges: RectEdge
   public let radius: CGFloat

   private var layers: [RectEdge: CALayer] = [:]

   override public var bounds: CGRect {
      didSet {
         update()
      }
   }

   override public init(layer: Any) {
      if let layer = layer as? InnerShadowLayer {
         edges = layer.edges
         radius = layer.radius
         super.init(layer: layer)
      } else {
         fatalError()
      }
   }

   public init(frame: CGRect = .zero, edges: RectEdge = .all, radius: CGFloat = 3.0, opacity: Float = 0.5,
               color: Color = Color.black) {
      self.edges = edges
      self.radius = radius
      super.init()

      if edges.contains(.top) {
         let gradientLayer = makeLayer(color: color, opacity: opacity)
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
         gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
         layers[.top] = gradientLayer
      }
      if edges.contains(.bottom) {
         let gradientLayer = makeLayer(color: color, opacity: opacity)
         gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
         gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
         layers[.bottom] = gradientLayer
      }
      if edges.contains(.left) {
         let gradientLayer = makeLayer(color: color, opacity: opacity)
         gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
         layers[.left] = gradientLayer
      }
      if edges.contains(.right) {
         let gradientLayer = makeLayer(color: color, opacity: opacity)
         gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
         gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.5)
         layers[.right] = gradientLayer
      }

      for (_, layer) in layers {
         addSublayer(layer)
      }

      self.frame = frame // Will call `update()` via setter.
   }

   required init?(coder: NSCoder) {
      fatalError()
   }

   private func update() {
      for (edge, layer) in layers {
         switch edge {
         case .top:
            layer.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: radius)
         case .bottom:
            layer.frame = CGRect(x: 0.0, y: frame.height - radius, width: frame.width, height: radius)
         case .left:
            layer.frame = CGRect(x: 0.0, y: 0.0, width: radius, height: frame.height)
         case .right:
            layer.frame = CGRect(x: frame.width - radius, y: 0.0, width: radius, height: frame.height)
         default:
            break
         }
      }
   }

   private func makeLayer(color: Color, opacity: Float) -> CAGradientLayer {
      let fromColor = color.cgColor
      let toColor = Color.clear.cgColor
      let gradientLayer = CAGradientLayer()
      gradientLayer.colors = [fromColor, toColor]
      gradientLayer.opacity = opacity
      return gradientLayer
   }
}
#endif
