//
//  ViewsFactory.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.07.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public struct ViewsFactory {

   class Line: View {}

   public static func horizontalLine(height: CGFloat? = nil, colour: NSColor = .black) -> View {
      let view = Line()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = colour
      let heightValue = height ?? view.convertFromBacking(1)
      let c = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                 multiplier: 1, constant: heightValue)
      view.addConstraint(c)
      return view
   }

   public static func verticalLine(width: CGFloat? = nil, colour: NSColor = .black) -> View {
      let view = Line()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = colour
      let heightValue = width ?? view.convertFromBacking(1)
      let c = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,
                                 multiplier: 1, constant: heightValue)
      view.addConstraint(c)
      return view
   }
}
#endif
