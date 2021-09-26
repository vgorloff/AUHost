//
//  SegmentedControl.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class SegmentedControl: NSSegmentedControl {

   public convenience init(trackingMode: NSSegmentedControl.SwitchTracking) {
      self.init(frame: .zero)
      self.trackingMode = trackingMode
   }

   public convenience init(segmentStyle: NSSegmentedControl.Style) {
      self.init(frame: .zero)
      self.segmentStyle = segmentStyle
   }

   @available(OSX 10.13, *)
   public convenience init(segmentDistribution: NSSegmentedControl.Distribution) {
      self.init(frame: .zero)
      self.segmentDistribution = segmentDistribution
   }
}

extension NSSegmentedControl {

   public func appendSegment(withTitle title: String) {
      let index = segmentCount
      segmentCount += 1
      setLabel(title, forSegment: index)
   }
}

extension NSSegmentedControl.SwitchTracking {

   public static let allValues: [NSSegmentedControl.SwitchTracking] = [selectOne, selectAny, momentary, momentaryAccelerator]

   public var stringValue: String {
      switch self {
      case .momentary:
         return "momentary"
      case .momentaryAccelerator:
         return "momentaryAccelerator"
      case .selectAny:
         return "selectAny"
      case .selectOne:
         return "selectOne"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}

@available(OSX 10.13, *)
extension NSSegmentedControl.Distribution {

   public static let allValues: [NSSegmentedControl.Distribution] = [fill, fillEqually, fillProportionally, fit]

   public var stringValue: String {
      switch self {
      case .fill:
         return "fill"
      case .fillEqually:
         return "fillEqually"
      case .fillProportionally:
         return "fillProportionally"
      case .fit:
         return "fit"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}

extension NSSegmentedControl.Style {
   public static let allValues: [NSSegmentedControl.Style] = [automatic, rounded, roundRect, texturedSquare, smallSquare,
                                                              separated, texturedRounded, capsule]

   public var stringValue: String {
      switch self {
      case .automatic:
         return "automatic"
      case .rounded:
         return "rounded"
      case .roundRect:
         return "roundRect"
      case .texturedSquare:
         return "texturedSquare"
      case .smallSquare:
         return "smallSquare"
      case .separated:
         return "separated"
      case .texturedRounded:
         return "texturedRounded"
      case .capsule:
         return "capsule"
      @unknown default:
         assertionFailure("Unknown value: \"\(self)\". Please update \(#file)")
         return "Unknown"
      }
   }
}
#endif
