//
//  TextField.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.04.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class TextField: UITextField {

   var onDeleteBackward: ((UITextField) -> Void)?

   override public init(frame: CGRect) {
      // Fix for wrong value of `layoutMarginsGuide` on iOS 10 https://stackoverflow.com/a/49255958/1418981
      var adjustedFrame = frame
      if frame.size.width == 0 {
         adjustedFrame.size.width = CGFloat.leastNormalMagnitude
      }
      if frame.size.height == 0 {
         adjustedFrame.size.height = CGFloat.leastNormalMagnitude
      }
      super.init(frame: adjustedFrame)
      setupUI()
      setupHandlers()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   override open func deleteBackward() {
      super.deleteBackward()
      onDeleteBackward?(self)
   }

   open func setupUI() {
   }

   open func setupHandlers() {
   }
}

extension UITextField {

   public func setAdjustsFontSizeToFitWidth(minimumFontSize: CGFloat) {
      adjustsFontSizeToFitWidth = true
      self.minimumFontSize = minimumFontSize
   }
}

extension UITextField {

   public final class GenericDelegate: NSObject {

      public var eventHandler: ((Event) -> Void)?
      public var actionHandler: ((Action) -> Bool)?

      override public init() {
         super.init()
      }

      deinit {
      }
   }
}

extension UITextField.GenericDelegate {

   public enum Event {
      case didBeginEditing(UITextField)
      case didEndEditing(UITextField)
   }

   public enum Action {
      case shouldChangeCharacters(UITextField, NSRange, String)
      case shouldReturn(UITextField)
   }
}

extension UITextField.GenericDelegate: UITextFieldDelegate {

   public func textFieldDidBeginEditing(_ textField: UITextField) {
      eventHandler?(.didBeginEditing(textField))
   }

   public func textFieldDidEndEditing(_ textField: UITextField) {
      eventHandler?(.didEndEditing(textField))
   }

   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                         replacementString string: String) -> Bool {
      return actionHandler?(.shouldChangeCharacters(textField, range, string)) ?? true
   }

   public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      return actionHandler?(.shouldReturn(textField)) ?? true
   }
}
#endif
