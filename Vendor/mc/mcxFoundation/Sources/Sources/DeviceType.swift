//
//  DeviceType.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08/08/2018.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import UIKit

// See also:
// - http://iosres.com
// - https://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
public enum DeviceType {

   public static let isPhone = UIDevice.current.userInterfaceIdiom == .phone
   public static let isPad = UIDevice.current.userInterfaceIdiom == .pad

   public static var isPhone5OrLess: Bool {
      return DeviceType.isPhone && ScreenSize.maxLength <= 568.0 // Smallest screen we support.
   }

   public static var isPhone6Or7: Bool {
      return DeviceType.isPhone && ScreenSize.maxLength == 667.0
   }

   public static var isPhone6POr7P: Bool {
      return DeviceType.isPhone && ScreenSize.maxLength == 736.0
   }

   public static var isPadProBig: Bool {
      return DeviceType.isPad && ScreenSize.maxLength == 1366.0
   }
}
#endif
