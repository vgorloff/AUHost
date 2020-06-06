//
//  LayersFactory.swift
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

public struct LayersFactory {

   #if os(iOS) || os(tvOS)
   public typealias Color = UIColor
   public typealias RectEdge = UIRectEdge
   #elseif os(OSX)
   public typealias Color = NSColor
   public typealias RectEdge = NSRectEdge
   #endif

   #if os(iOS) || os(tvOS)
   public func roundedInnerShadow(frame: CGRect = .zero, color: Color = .black, opacity: Float = 0.5,
                                  offset: CGSize = CGSize(width: 0, height: 0),
                                  blurRadius: CGFloat = 3, cornerRadius: CGFloat = 0) -> RoundedInnerShadowLayer {

      return RoundedInnerShadowLayer(frame: frame, color: color, opacity: opacity, offset: offset,
                                     blurRadius: blurRadius, cornerRadius: cornerRadius)
   }

   public func borders(frame: CGRect = .zero, edges: RectEdge = .all, color: Color = .black,
                       thickness: CGFloat = 1) -> BorderLayer {
      return BorderLayer(frame: frame, edges: edges, color: color, thickness: thickness)
   }
   #endif
}
