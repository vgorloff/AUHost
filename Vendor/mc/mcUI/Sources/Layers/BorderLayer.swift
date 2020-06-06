//
//  BorderLayer.swift
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
public class BorderLayer: CALayer {

   #if os(iOS) || os(tvOS)
   public typealias RectEdge = UIRectEdge
   #elseif os(OSX)
   public typealias RectEdge = NSRectEdge
   #endif

   public let edges: RectEdge
   public let thickness: CGFloat

   private var layers: [RectEdge: CALayer] = [:]

   override public var bounds: CGRect {
      didSet {
         update()
      }
   }

   public init(frame: CGRect = .zero, edges: RectEdge = .all, color: Color = .black, thickness: CGFloat = 1) {
      self.edges = edges
      self.thickness = thickness
      super.init()

      if edges.contains(.top) {
         layers[.top] = CALayer()
      }

      if edges.contains(.bottom) {
         layers[.bottom] = CALayer()
      }

      if edges.contains(.left) {
         layers[.left] = CALayer()
      }

      if edges.contains(.right) {
         layers[.right] = CALayer()
      }

      for (_, layer) in layers {
         layer.backgroundColor = color.cgColor
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
            layer.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
         case .bottom:
            layer.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
         case .left:
            layer.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
         case .right:
            layer.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
         default:
            break
         }
      }
   }
}
#endif
