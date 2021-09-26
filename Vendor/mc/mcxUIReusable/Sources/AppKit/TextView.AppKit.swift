//
//  TextView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcxFoundationObservables
import mcxTypes

open class TextView: NSTextView {

   public var onTextDidChange = EventHandler<String>()

   private var observers: [NotificationObserver] = []

   override public init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
      super.init(frame: frameRect, textContainer: container)
      setupNotifications()
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
      translatesAutoresizingMaskIntoConstraints = false
   }

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
   }

   @available(*, unavailable)
   public required init?(coder: NSCoder) {
      fatalError()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }

   private func setupNotifications() {
      observers.append(NotificationObserver(name: NSText.didChangeNotification, object: self, queue: .main) { [weak self] _ in
         if let this = self {
            self?.onTextDidChange.fire(this.string)
         }
      })
   }
}
#endif
