//
//  NSBezierPath.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSBezierPath {

   public var cgPath: CGPath {
      let path = CGMutablePath()
      var points = [CGPoint](repeating: .zero, count: 3)
      for i in 0 ..< elementCount {
         let type = element(at: i, associatedPoints: &points)
         switch type {
         case .moveTo: path.move(to: points[0])
         case .lineTo: path.addLine(to: points[0])
         case .curveTo: path.addCurve(to: points[2], control1: points[0], control2: points[1])
         case .closePath: path.closeSubpath()
         @unknown default:
            assertionFailure("Unknown value: \"\(type)\". Please update \(#file)")
         }
      }
      return path
   }
}

extension NSBezierPath {

   // Just to have same methods as in iOS.
   public func addLine(to: NSPoint) {
      line(to: to)
   }
}
#endif
