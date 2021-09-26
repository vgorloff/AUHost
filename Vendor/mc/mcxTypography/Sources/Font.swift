//
//  Font.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24/02/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

#if os(iOS) || os(tvOS)

extension UIFont {

   public static func fixedRegular(size: CGFloat, family: FontFamily? = nil) -> UIFont {
      if let family = family {
         return UIFont(descriptor: family.fontDescriptor(weight: .regular), size: size)
      } else {
         return UIFont.systemFont(ofSize: size, weight: .regular)
      }
   }

   public static func fixedMedium(size: CGFloat, family: FontFamily? = nil) -> UIFont {
      if let family = family {
         return UIFont(descriptor: family.fontDescriptor(weight: .medium), size: size)
      } else {
         return UIFont.systemFont(ofSize: size, weight: .medium)
      }
   }

   public static func fixedSemibold(size: CGFloat, family: FontFamily? = nil) -> UIFont {
      if let family = family {
         return UIFont(descriptor: family.fontDescriptor(weight: .semibold), size: size)
      } else {
         return UIFont.systemFont(ofSize: size, weight: .semibold)
      }
   }

   public static func fixedBold(size: CGFloat, family: FontFamily? = nil) -> UIFont {
      if let family = family {
         return UIFont(descriptor: family.fontDescriptor(weight: .bold), size: size)
      } else {
         return UIFont.systemFont(ofSize: size, weight: .bold)
      }
   }

   public static func fixedHeavy(size: CGFloat, family: FontFamily? = nil) -> UIFont {
      if let family = family {
         return UIFont(descriptor: family.fontDescriptor(weight: .heavy), size: size)
      } else {
         return UIFont.systemFont(ofSize: size, weight: .heavy)
      }
   }

   public static func fixedItalic(size: CGFloat, family: FontFamily? = nil) -> UIFont {
      if let family = family, let descriptor = family.fontDescriptor(weight: .regular).withSymbolicTraits(.traitItalic) {
         return UIFont(descriptor: descriptor, size: size)
      } else {
         return UIFont.italicSystemFont(ofSize: size)
      }
   }

   public static func regular(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedRegular(size: size))
      } else {
         return fixedRegular(size: scaledSize(for: style, size: size))
      }
   }

   public static func medium(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedMedium(size: size))
      } else {
         return fixedMedium(size: scaledSize(for: style, size: size))
      }
   }

   public static func semibold(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedSemibold(size: size))
      } else {
         return fixedSemibold(size: scaledSize(for: style, size: size))
      }
   }

   public static func bold(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedBold(size: size))
      } else {
         return fixedBold(size: scaledSize(for: style, size: size))
      }
   }

   public static func heavy(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedHeavy(size: size))
      } else {
         return fixedHeavy(size: scaledSize(for: style, size: size))
      }
   }

   public static func italic(size: CGFloat, style: UIFont.TextStyle = .body) -> UIFont {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return UIFontMetrics(forTextStyle: style).scaledFont(for: fixedItalic(size: size))
      } else {
         return fixedItalic(size: scaledSize(for: style, size: size))
      }
   }

   /**
    This method calculates size for scaled font. It is used only for ios9-10.

    IMPORTANT: This method works incorrectly, for large fonts it returns much bigger size than it should be.
    */
   private static func scaledSize(for style: UIFont.TextStyle, size: CGFloat) -> CGFloat {
      var defaultSizes: [UIFont.TextStyle: CGFloat] = [.title1: 28,
                                                       .title2: 22,
                                                       .title3: 20,
                                                       .headline: 17,
                                                       .body: 17,
                                                       .callout: 16,
                                                       .subheadline: 15,
                                                       .footnote: 13,
                                                       .caption1: 12,
                                                       .caption2: 11]
      #if os(iOS)
      if #available(iOS 11.0, *) {
         defaultSizes[.largeTitle] = 34
      }
      #endif
      let fd = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
      let defaultSize = defaultSizes[style] ?? 17.0
      return fd.pointSize + (size - defaultSize)
   }
}

#elseif os(OSX)

extension NSFont {

   public static func semibold(size: CGFloat, family: FontFamily? = nil) -> NSFont {
      if let family = family, let font = NSFont(descriptor: family.fontDescriptor(weight: .semibold), size: size) {
         return font
      } else {
         return NSFont.systemFont(ofSize: size, weight: .semibold)
      }
   }

   public static func medium(size: CGFloat, family: FontFamily? = nil) -> NSFont {
      if let family = family, let font = NSFont(descriptor: family.fontDescriptor(weight: .medium), size: size) {
         return font
      } else {
         return NSFont.systemFont(ofSize: size, weight: .medium)
      }
   }

   public static func regular(size: CGFloat, family: FontFamily? = nil) -> NSFont {
      if let family = family, let font = NSFont(descriptor: family.fontDescriptor(weight: .regular), size: size) {
         return font
      } else {
         return NSFont.systemFont(ofSize: size, weight: .regular)
      }
   }

   public static func light(size: CGFloat, family: FontFamily? = nil) -> NSFont {
      if let family = family, let font = NSFont(descriptor: family.fontDescriptor(weight: .light), size: size) {
         return font
      } else {
         return NSFont.systemFont(ofSize: size, weight: .light)
      }
   }
}
#endif
