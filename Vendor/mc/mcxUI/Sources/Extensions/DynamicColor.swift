//
//  DynamicColor.swift
//  Decode
//
//  Created by Vlad Gorlov on 07.03.21.
//

import Foundation
import mcxGraphicsExtensions

public class DynamicColor {

   public let light: Alias.Color
   public let dark: Alias.Color
   public let dynamic: Alias.Color

   public init(light: Alias.Color, dark: Alias.Color) {
      self.dark = dark
      self.light = light
      dynamic = Alias.Color.dynamicColor(light: light, dark: dark)
   }
}

extension DynamicColor {

   public func withAppearance(_ appearance: SystemAppearance) -> Alias.Color {
      return appearance.isDark ? dark : light
   }
}
