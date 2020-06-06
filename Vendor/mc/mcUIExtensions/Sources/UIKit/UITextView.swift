//
//  UITextView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UITextView {

   @objc(UITextViewGenericDelegate)
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

extension UITextView.GenericDelegate {

   public enum Event {
      case didBeginEditing(UITextView)
      case didEndEditing(UITextView)
   }

   public enum Action {
      case shouldChangeCharacters(UITextView, NSRange, String)
   }
}

extension UITextView.GenericDelegate: UITextViewDelegate {

   public func textViewDidBeginEditing(_ textView: UITextView) {
      eventHandler?(.didBeginEditing(textView))
   }

   public func textViewDidEndEditing(_ textView: UITextView) {
      eventHandler?(.didEndEditing(textView))
   }

   public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
      return actionHandler?(.shouldChangeCharacters(textView, range, text)) ?? true
   }
}
#endif
