//
//  UITextField.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UITextField {

   public enum KeyboardPreset: Int {
      case email, name, familyName, id, phone
      case streetAddressLine1, streetAddressLine2, city, postalCode
   }

   public func setKeyboardPreset(_ type: KeyboardPreset) {
      switch type {
      case .email:
         keyboardType = .emailAddress
         autocorrectionType = .no
         autocapitalizationType = .none
         textContentType = .emailAddress
      case .name:
         keyboardType = .default
         autocorrectionType = .no
         autocapitalizationType = .words
         textContentType = .name
      case .familyName:
         keyboardType = .default
         autocorrectionType = .no
         autocapitalizationType = .words
         textContentType = .familyName
      case .id:
         keyboardType = .asciiCapableNumberPad
         autocorrectionType = .no
         autocapitalizationType = .none
      case .streetAddressLine1:
         keyboardType = .asciiCapable
         autocorrectionType = .default
         autocapitalizationType = .words
         textContentType = .streetAddressLine1
      case .streetAddressLine2:
         keyboardType = .asciiCapable
         autocorrectionType = .default
         autocapitalizationType = .words
         textContentType = .streetAddressLine2
      case .city:
         keyboardType = .asciiCapable
         autocorrectionType = .default
         autocapitalizationType = .words
         textContentType = .addressCity
      case .postalCode:
         keyboardType = .asciiCapableNumberPad
         autocorrectionType = .default
         autocapitalizationType = .words
         textContentType = .postalCode
      case .phone:
         keyboardType = .phonePad
         autocorrectionType = .no
         autocapitalizationType = .none
         textContentType = .telephoneNumber
      }
   }
}
#endif
