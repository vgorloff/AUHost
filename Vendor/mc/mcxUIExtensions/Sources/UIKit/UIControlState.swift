//
//  UIControlState.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIControl.State {

   public var stringValue: String {
      if #available(iOS 9.0, *) {
         switch self {
         case UIControl.State.normal: return "Normal"
         case UIControl.State.highlighted: return "Highlighted"
         case UIControl.State.disabled: return "Disabled"
         case UIControl.State.selected: return "Selected"
         case UIControl.State.focused: return "Focused"
         case UIControl.State.application: return "Application"
         case UIControl.State.reserved: return "Reserved"
         default: return "Unknown"
         }
      } else {
         switch self {
         case UIControl.State.normal: return "Normal"
         case UIControl.State.highlighted: return "Highlighted"
         case UIControl.State.disabled: return "Disabled"
         case UIControl.State.selected: return "Selected"
         case UIControl.State.application: return "Application"
         case UIControl.State.reserved: return "Reserved"
         default: return "Unknown"
         }
      }
   }
}
#endif
