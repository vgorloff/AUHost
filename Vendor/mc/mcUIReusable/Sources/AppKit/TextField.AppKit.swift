//
//  TextField.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24.09.17.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class TextField: NSTextField {

   public var onTextDidChangeHandler: ((String) -> Void)?

   override public init(frame: CGRect) {
      super.init(frame: frame)
      translatesAutoresizingMaskIntoConstraints = false
      initializeView()
   }

   public required init?(coder decoder: NSCoder) {
      fatalError()
   }

   override open func textDidChange(_ notification: Notification) {
      super.textDidChange(notification)
      onTextDidChangeHandler?(text)
   }

   open func initializeView() {
      // Do something
   }

   public func setEditingDidEndHandler<T: AnyObject>(_ caller: T, _ handler: @escaping (T) -> Void) {
      super.setHandler(caller, handler)
   }
}
#endif
