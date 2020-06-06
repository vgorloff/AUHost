//
//  Math.BezierPath.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import CoreGraphics

extension Math {

   // Info:
   // - Draw a Smooth Curve: https://www.codeproject.com/Articles/31859/Draw-a-Smooth-Curve-through-a-Set-of-D-Points-wit
   // - ObjC version of this code: https://github.com/ImJCabus/UIBezierPath-Length/blob/master/UIBezierPath%2BLength.m
   // - Bézier curve - Wikipedia: https://en.m.wikipedia.org/wiki/B%C3%A9zier_curve
   public class BezierPath {

      public let cgPath: CGPath
      public let approximationIterations: Int

      private(set) lazy var subpaths = processSubpaths(iterations: approximationIterations)
      public private(set) lazy var length = subpaths.reduce(CGFloat(0)) { $0 + $1.length }

      public init(cgPath: CGPath, approximationIterations: Int = 100) {
         self.cgPath = cgPath
         self.approximationIterations = approximationIterations
      }
   }
}

extension Math.BezierPath {

   public func point(atPercentOfLength: CGFloat) -> CGPoint {

      var percent = atPercentOfLength
      if percent < 0 {
         percent = 0
      } else if percent > 1 {
         percent = 1
      }

      let pointLocationInPath = length * percent
      var currentLength: CGFloat = 0
      var subpathContainingPoint = Subpath(type: .moveToPoint)
      for element in subpaths {
         if currentLength + element.length >= pointLocationInPath {
            subpathContainingPoint = element
            break
         } else {
            currentLength += element.length
         }
      }

      let lengthInSubpath = pointLocationInPath - currentLength
      if subpathContainingPoint.length == 0 {
         return subpathContainingPoint.endPoint
      } else {
         let t = lengthInSubpath / subpathContainingPoint.length
         return point(atPercent: t, of: subpathContainingPoint)
      }
   }
}

extension Math.BezierPath {

   struct Subpath {

      var startPoint: CGPoint = .zero
      var controlPoint1: CGPoint = .zero
      var controlPoint2: CGPoint = .zero
      var endPoint: CGPoint = .zero
      var length: CGFloat = 0

      let type: CGPathElementType

      init(type: CGPathElementType) {
         self.type = type
      }
   }

   private typealias SubpathEnumerator = @convention(block) (CGPathElement) -> Void

   private func enumerateSubpaths(body: @escaping SubpathEnumerator) {
      func applier(info: UnsafeMutableRawPointer?, element: UnsafePointer<CGPathElement>) {
         if let info = info {
            let callback = unsafeBitCast(info, to: SubpathEnumerator.self)
            callback(element.pointee)
         }
      }
      let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
      cgPath.apply(info: unsafeBody, function: applier)
   }

   func processSubpaths(iterations: Int) -> [Subpath] {

      var subpathArray: [Subpath] = []
      var currentPoint = CGPoint.zero
      var moveToPointSubpath: Subpath?
      enumerateSubpaths { element in
         let elType = element.type
         let points = element.points
         var subLength: CGFloat = 0
         var endPoint = CGPoint.zero
         var subpath = Subpath(type: elType)
         subpath.startPoint = currentPoint

         switch elType {
         case .moveToPoint:
            endPoint = points[0]
         case .addLineToPoint:
            endPoint = points[0]
            subLength = type(of: self).linearLineLength(from: currentPoint, to: endPoint)
         case .addQuadCurveToPoint:
            endPoint = points[1]
            let controlPoint = points[0]
            subLength = type(of: self).quadCurveLength(from: currentPoint, to: endPoint, controlPoint: controlPoint,
                                                       iterations: iterations)
            subpath.controlPoint1 = controlPoint
         case .addCurveToPoint:
            endPoint = points[2]
            let controlPoint1 = points[0]
            let controlPoint2 = points[1]
            subLength = type(of: self).cubicCurveLength(from: currentPoint, to: endPoint, controlPoint1: controlPoint1,
                                                        controlPoint2: controlPoint2, iterations: iterations)
            subpath.controlPoint1 = controlPoint1
            subpath.controlPoint2 = controlPoint2
         case .closeSubpath:
            break
         @unknown default:
            assertionFailure("Unknown value: \"\(elType)\". Please update \(#file)")
         }
         subpath.length = subLength
         subpath.endPoint = endPoint
         if elType != .moveToPoint {
            subpathArray.append(subpath)
         } else {
            moveToPointSubpath = subpath
         }
         currentPoint = endPoint
      }

      if subpathArray.isEmpty, let subpath = moveToPointSubpath {
         subpathArray.append(subpath)
      }
      return subpathArray
   }

   private func point(atPercent t: CGFloat, of subpath: Subpath) -> CGPoint {
      var p = CGPoint.zero
      switch subpath.type {
      case .addLineToPoint:
         p = type(of: self).linearBezierPoint(t: t, start: subpath.startPoint, end: subpath.endPoint)
      case .addQuadCurveToPoint:
         p = type(of: self).quadBezierPoint(t: t, start: subpath.startPoint, c1: subpath.controlPoint1, end: subpath.endPoint)
      case .addCurveToPoint:
         p = type(of: self).cubicBezierPoint(t: t, start: subpath.startPoint, c1: subpath.controlPoint1, c2: subpath.controlPoint2,
                                             end: subpath.endPoint)
      default:
         break
      }
      return p
   }
}

extension Math.BezierPath {

   @inline(__always)
   public static func linearLineLength(from: CGPoint, to: CGPoint) -> CGFloat {
      return sqrt(pow(to.x - from.x, 2) + pow(to.y - from.y, 2))
   }

   public static func quadCurveLength(from: CGPoint, to: CGPoint, controlPoint: CGPoint, iterations: Int) -> CGFloat {
      var length: CGFloat = 0
      let divisor = 1.0 / CGFloat(iterations)

      for idx in 0 ..< iterations {
         let t = CGFloat(idx) * divisor
         let tt = t + divisor
         let p = quadBezierPoint(t: t, start: from, c1: controlPoint, end: to)
         let pp = quadBezierPoint(t: tt, start: from, c1: controlPoint, end: to)
         length += linearLineLength(from: p, to: pp)
      }
      return length
   }

   public static func cubicCurveLength(from: CGPoint, to: CGPoint, controlPoint1: CGPoint,
                                       controlPoint2: CGPoint, iterations: Int) -> CGFloat {
      let iterations = 100
      var length: CGFloat = 0
      let divisor = 1.0 / CGFloat(iterations)

      for idx in 0 ..< iterations {
         let t = CGFloat(idx) * divisor
         let tt = t + divisor
         let p = cubicBezierPoint(t: t, start: from, c1: controlPoint1, c2: controlPoint2, end: to)
         let pp = cubicBezierPoint(t: tt, start: from, c1: controlPoint1, c2: controlPoint2, end: to)
         length += linearLineLength(from: p, to: pp)
      }
      return length
   }

   @inline(__always)
   public static func linearBezierPoint(t: CGFloat, start: CGPoint, end: CGPoint) -> CGPoint {
      let dx = end.x - start.x
      let dy = end.y - start.y
      let px = start.x + (t * dx)
      let py = start.y + (t * dy)
      return CGPoint(x: px, y: py)
   }

   @inline(__always)
   public static func quadBezierPoint(t: CGFloat, start: CGPoint, c1: CGPoint, end: CGPoint) -> CGPoint {
      let x = QuadBezier(t: t, start: start.x, c1: c1.x, end: end.x)
      let y = QuadBezier(t: t, start: start.y, c1: c1.y, end: end.y)
      return CGPoint(x: x, y: y)
   }

   @inline(__always)
   public static func cubicBezierPoint(t: CGFloat, start: CGPoint, c1: CGPoint, c2: CGPoint, end: CGPoint) -> CGPoint {
      let x = CubicBezier(t: t, start: start.x, c1: c1.x, c2: c2.x, end: end.x)
      let y = CubicBezier(t: t, start: start.y, c1: c1.y, c2: c2.y, end: end.y)
      return CGPoint(x: x, y: y)
   }

   /*
    *  http://ericasadun.com/2013/03/25/calculating-bezier-points/
    */
   @inline(__always)
   public static func CubicBezier(t: CGFloat, start: CGFloat, c1: CGFloat, c2: CGFloat, end: CGFloat) -> CGFloat {
      let t_ = (1.0 - t)
      let tt_ = t_ * t_
      let ttt_ = t_ * t_ * t_
      let tt = t * t
      let ttt = t * t * t

      return start * ttt_
         + 3.0 * c1 * tt_ * t
         + 3.0 * c2 * t_ * tt
         + end * ttt
   }

   /*
    *  http://ericasadun.com/2013/03/25/calculating-bezier-points/
    */
   @inline(__always)
   public static func QuadBezier(t: CGFloat, start: CGFloat, c1: CGFloat, end: CGFloat) -> CGFloat {
      let t_ = (1.0 - t)
      let tt_ = t_ * t_
      let tt = t * t

      return start * tt_
         + 2.0 * c1 * t_ * t
         + end * tt
   }
}
