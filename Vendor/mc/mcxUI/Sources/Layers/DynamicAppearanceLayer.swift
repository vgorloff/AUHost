//
//  DynamicAppearanceLayer.swift
//  Playgrounds
//
//  Created by Vlad Gorlov on 07.03.21.
//

import Foundation
import QuartzCore

public class DynamicAppearanceLayer: CALayer {

   public var borderDynamicColor: DynamicColor? {
      didSet {
         updateBorderColor()
      }
   }

   public var appearance: SystemAppearance = .light {
      didSet {
         updateBorderColor()
      }
   }

   override public init() {
      super.init()
      updateBorderColor()
   }

   override public init(layer: Any) {
      super.init(layer: layer)
      updateBorderColor()
   }

   @available(*, unavailable)
   required init?(coder: NSCoder) {
      fatalError()
   }

   private func updateBorderColor() {
      let color = appearance.isDark ? borderDynamicColor?.dark : borderDynamicColor?.light
      borderColor = color?.cgColor
   }
}
