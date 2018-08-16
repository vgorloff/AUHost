//
//  Color.swift
//  mcFoundation
//
//  Created by Volodymyr Gorlov on 04.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

#if os(iOS) || os(tvOS) || os(watchOS)
   import UIKit
   public typealias Color = UIColor
#elseif os(OSX)
   import AppKit
   public typealias Color = NSColor
#endif

extension Color {

   public convenience init(hexValue hex: UInt64) {
      let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
      let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
      let blue = CGFloat(hex & 0xFF) / 255.0
      self.init(red: red, green: green, blue: blue, alpha: 1)
   }

   public convenience init?(hexString: String) {
      let scanner = Scanner(string:
         hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
      guard scanner.scanString("#", into: nil) else {
         return nil
      }
      guard (scanner.string.count - scanner.scanLocation) == 6 else {
         return nil
      }
      var hexNumber: UInt64 = 0
      if scanner.scanHexInt64(&hexNumber) {
         self.init(hexValue: hexNumber)
         return
      }
      return nil
   }

   public convenience init?(rgba: String, rgbCompomentsIn256Range: Bool = false) {
      var rgbaValue = rgba.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
      rgbaValue = rgbaValue.lowercased()
      let scanner = Scanner(string: rgbaValue)
      guard scanner.scanString("rgba(", into: nil) else {
         return nil
      }
      var r: Float = 0
      var g: Float = 0
      var b: Float = 0
      var a: Float = 0
      guard
         scanner.scanFloat(&r) && scanner.scanString(",", into: nil) &&
         scanner.scanFloat(&g) && scanner.scanString(",", into: nil) &&
         scanner.scanFloat(&b) && scanner.scanString(",", into: nil) &&
         scanner.scanFloat(&a) && scanner.scanString(")", into: nil) else {
         return nil
      }
      if rgbCompomentsIn256Range {
         r /= 255.0
         g /= 255.0
         b /= 255.0
      }
      assert(r <= 1 && g <= 1 && b <= 1 && a <= 1)
      self.init(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
   }
}

extension Color {

   public var lighterColor: Color {
      var r = CGFloat(0)
      var g = CGFloat(0)
      var b = CGFloat(0)
      var a = CGFloat(0)
      #if os(iOS)
         if !getRed(&r, green: &g, blue: &b, alpha: &a) {
            assert(false, "Unable to get lighter color for color: \(self)")
            return self
         }
      #else
         getRed(&r, green: &g, blue: &b, alpha: &a)
      #endif
      r = min(r + 0.2, 1.0)
      g = min(g + 0.2, 1.0)
      b = min(b + 0.2, 1.0)
      let color = Color(red: r, green: g, blue: b, alpha: a)
      return color
   }

   public var darkerColor: Color {
      var r = CGFloat(0)
      var g = CGFloat(0)
      var b = CGFloat(0)
      var a = CGFloat(0)
      #if os(iOS)
         if !getRed(&r, green: &g, blue: &b, alpha: &a) {
            assert(false, "Unable to get lighter color for color: \(self)")
            return self
         }
      #else
         getRed(&r, green: &g, blue: &b, alpha: &a)
      #endif
      r = min(r - 0.2, 1.0)
      g = min(g - 0.2, 1.0)
      b = min(b - 0.2, 1.0)
      let color = Color(red: r, green: g, blue: b, alpha: a)
      return color
   }

   public static var random: Color {
      let hue: CGFloat = RandomFactory.value(in: 0 ... 1)
      let saturation: CGFloat = RandomFactory.value(in: 0 ... 1)
      let brightness: CGFloat = RandomFactory.value(in: 0 ... 1)
      return Color(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
   }

}

extension Color {

   public struct RGBComponents {
      let r: CGFloat
      let g: CGFloat
      let b: CGFloat
      let alpha: CGFloat
   }

   public struct GrayscaleComponents {
      let white: CGFloat
      let alpha: CGFloat
   }

   public enum ColorComponents {
      case rgb(RGBComponents)
      case grayscale(GrayscaleComponents)
   }

   public var rgbaComponents: ColorComponents {
      var r = CGFloat(0)
      var g = CGFloat(0)
      var b = CGFloat(0)
      var alpha = CGFloat(0)
      var white = CGFloat(0)
      #if !os(OSX)
      if getRed(&r, green: &g, blue: &b, alpha: &alpha) {
         return .rgb(RGBComponents(r: r, g: g, b: b, alpha: alpha))
      } else if getWhite(&white, alpha: &alpha) {
         return .grayscale(GrayscaleComponents(white: white, alpha: alpha))
      } else {
         assert(false, "Unable to get color components from color: \(self)")
         return .rgb(RGBComponents(r: 0, g: 0, b: 0, alpha: 1))
      }
      #else
      let rgbColorSpaces: [NSColorSpace] = [.genericRGB, .deviceRGB, .sRGB]
      let alphaColorSpaces: [NSColorSpace] = [.genericGray, .deviceGray, .genericGamma22Gray]
      if rgbColorSpaces.contains(colorSpace) {
         getRed(&r, green: &g, blue: &b, alpha: &alpha)
         return .rgb(RGBComponents(r: r, g: g, b: b, alpha: alpha))
      } else if alphaColorSpaces.contains(colorSpace) {
         getWhite(&white, alpha: &alpha)
         return .grayscale(GrayscaleComponents(white: white, alpha: alpha))
      } else {
         assert(false, "Unable to get color components from color space: \(colorSpace)")
         return .rgb(RGBComponents(r: 0, g: 0, b: 0, alpha: 1))
      }
      #endif
   }
}

extension Color {

   public var cssRGBValue: String {
      switch rgbaComponents {
      case .grayscale(let color):
         if color.alpha == 1 {
            return String(format: "rgb(%u, %u, %u)",
                          toByte(component: color.white), toByte(component: color.white), toByte(component: color.white))
         } else {
            return String(format: "rgba(%u, %u, %u, %g)",
                          toByte(component: color.white), toByte(component: color.white), toByte(component: color.white),
                          color.alpha)
         }

      case .rgb(let color):
         if color.alpha == 1 {
            return String(format: "rgb(%u, %u, %u)",
                          toByte(component: color.r), toByte(component: color.g), toByte(component: color.b))
         } else {
            return String(format: "rgba(%u, %u, %u, %g)",
                          toByte(component: color.r), toByte(component: color.g), toByte(component: color.b), color.alpha)
         }
      }
   }

   public var cssHEXValue: String {
      // FIXME: `alpha` value is not used. We need to take it into account.
      switch rgbaComponents {
      case .grayscale(let color):
         return String(format: "#%02X%02X%02X",
                       toByte(component: color.white), toByte(component: color.white), toByte(component: color.white))
      case .rgb(let color):
         return String(format: "#%02X%02X%02X",
                       toByte(component: color.r), toByte(component: color.g), toByte(component: color.b))
      }
   }

   private func toByte(component: CGFloat) -> Int {
      let value = max(component, min(component, 1)) // Clamp
      return Int(round(value * 255))
   }
}

// Popular colors.
public extension Color {

   static let x080808 = #colorLiteral(red: 0.0313725490196078, green: 0.0313725490196078, blue: 0.0313725490196078, alpha: 1)
   static let x242424 = #colorLiteral(red: 0.1411764705882353, green: 0.1411764705882353, blue: 0.1411764705882353, alpha: 1)
   static let x313232 = #colorLiteral(red: 0.1921568627450981, green: 0.1960784313725490, blue: 0.1960784313725490, alpha: 1)
   static let x506743 = #colorLiteral(red: 0.3137254901960784, green: 0.4039215686274510, blue: 0.2627450980392157, alpha: 1)
   static let x7EC2AF = #colorLiteral(red: 0.4941176470588236, green: 0.7607843137254902, blue: 0.6862745098039216, alpha: 1)
   static let x90C0B2 = #colorLiteral(red: 0.5647058823529412, green: 0.7529411764705882, blue: 0.6980392156862745, alpha: 1)
   static let x90D4C8 = #colorLiteral(red: 0.5647058823529412, green: 0.8313725490196079, blue: 0.7843137254901961, alpha: 1)
   static let xA6DB8B = #colorLiteral(red: 0.6509803921568628, green: 0.8588235294117647, blue: 0.5450980392156862, alpha: 1)
   static let xAEAEAE = #colorLiteral(red: 0.6823529411764706, green: 0.6823529411764706, blue: 0.6823529411764706, alpha: 1)
   static let xB2B8C5 = #colorLiteral(red: 0.6980392156862745, green: 0.7215686274509804, blue: 0.7725490196078432, alpha: 1)
   static let xB5F3F0 = #colorLiteral(red: 0.7098039215686275, green: 0.9529411764705882, blue: 0.9411764705882353, alpha: 1)
   static let xBD11E7 = #colorLiteral(red: 0.7411764705882353, green: 0.0666666666666667, blue: 0.9058823529411765, alpha: 1)
   static let xDEDEDE = #colorLiteral(red: 0.8705882352941177, green: 0.8705882352941177, blue: 0.8705882352941177, alpha: 1)
   static let xEFEFF1 = #colorLiteral(red: 0.9372549019607843, green: 0.9372549019607843, blue: 0.9450980392156862, alpha: 1)
   static let xF0F0F0 = #colorLiteral(red: 0.9411764705882353, green: 0.9411764705882353, blue: 0.9411764705882353, alpha: 1)
   static let xF1F1F1 = #colorLiteral(red: 0.9450980392156862, green: 0.9450980392156862, blue: 0.9450980392156862, alpha: 1)
   static let xFAFAFA = #colorLiteral(red: 0.9803921568627451, green: 0.9803921568627451, blue: 0.9803921568627451, alpha: 1)
   static let xFEFEFE = #colorLiteral(red: 0.9960784313725490, green: 0.9960784313725490, blue: 0.9960784313725490, alpha: 1)
   static let xFF0000 = #colorLiteral(red: 1.0000000000000000, green: 0.0000000000000000, blue: 0.0000000000000000, alpha: 1)

}
