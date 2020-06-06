//
//  QuickLookFactory.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 18.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcFoundationExtensions
#if os(OSX)
import AppKit
#else
import UIKit
#endif

// See also:
// - https://developer.apple.com/library/archive/documentation/IDEs/Conceptual/CustomClassDisplay_in_QuickLook/
struct QuickLookFactory {

   #if os(OSX)
   private typealias BezierPath = NSBezierPath
   private typealias Image = NSImage
   #else
   private typealias BezierPath = UIBezierPath
   private typealias Image = UIImage
   #endif

   private static let height: Float = 120

   #if os(OSX)
   static func object(from value: QuickLookProxyType) -> AnyObject? {
      switch value {
      case .array1x(let data):
         return QuickLookFactory.object(from: data)
      case .array2x(let data):
         return QuickLookFactory.object(from: data)
      }
   }

   static func object(from data: [[Float]]) -> AnyObject? {
      let images = data.map { image(from: $0) }
      return stack(images: images)
   }

   static func object(from data: [Float]) -> AnyObject? {
      return image(from: data)
   }

   private static func image(from data: [Float]) -> Image {
      let size = CGSize(width: data.count, height: Int(height))
      return image(from: path(from: data), size: size)
   }

   private static func path(from data: [Float]) -> BezierPath {
      let path = BezierPath()
      var scale: Float = 1
      if let maxValue = data.max(), let minValue = data.min() {
         let maxValue = max(abs(minValue), abs(maxValue))
         scale = (0.5 * height) / maxValue
      }
      for (index, value) in data.enumerated() {
         let point = CGPoint(x: Float(index), y: value * scale)
         if index == 0 {
            path.move(to: point)
         } else {
            path.line(to: point)
         }
      }
      return path
   }

   private static func image(from path: BezierPath, size: CGSize) -> Image {
      let lineWidth: CGFloat = 1
      let paddings: CGFloat = 0.5 * lineWidth
      let size = size.insetBy(dx: 2 * -paddings, dy: 2 * -paddings)
      path.transform(using: AffineTransform(translationByX: paddings, byY: paddings + CGFloat(0.5 * height)))
      path.lineWidth = lineWidth
      return NSImage(size: size, flipped: false) { rect in
         NSColor.blue.setStroke()
         // NSColor.linkColor.setStroke()
         NSColor.white.setFill()
         rect.fill()
         path.stroke()
         return true
      }
   }

   private static func stack(images: [Image]) -> Image {
      let separatorWidth: CGFloat = 4
      let sizes = images.map { $0.size } // Assuming similar width and Height
      var maxHeight = sizes.map { $0.height }.reduce(0) { $0 + $1 }
      maxHeight += separatorWidth * CGFloat(images.count - 1)
      let size = CGSize(width: sizes.first?.width ?? 0, height: maxHeight)
      return NSImage(size: size, flipped: false) { _ in
         var offset: CGFloat = 0
         for image in images {
            image.draw(at: CGPoint(x: 0, y: offset), from: .zero, operation: .copy, fraction: 1)
            offset = image.size.height + separatorWidth
         }
         return true
      }
   }

   #else
   static func object(from value: QuickLookProxyType) -> AnyObject? {
      return nil
   }
   #endif
}
