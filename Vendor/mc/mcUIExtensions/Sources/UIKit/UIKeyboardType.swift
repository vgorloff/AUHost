//
//  UIKeyboardType.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIKeyboardType {

   // http://www.globalnerdy.com/2015/05/04/ios-8s-built-in-virtual-keyboards-on-the-iphone-a-visual-catalog/
   public static let keyboardTypesWithoutReturnButton = [UIKeyboardType.numberPad, .decimalPad, .phonePad]
}
#endif
