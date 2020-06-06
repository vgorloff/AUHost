//
//  ScrollView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcFoundationObservables
import mcUI

open class ScrollView: NSScrollView {

   private var observers: [NotificationObserver] = []

   public var onWillStartLiveScroll: (() -> Void)?
   public var onDidLiveScroll: (() -> Void)?
   public var onDidEndLiveScroll: (() -> Void)?

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      translatesAutoresizingMaskIntoConstraints = false
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
      setupNotifications()
      if #available(OSX 10.14, *) {
      } else {
         // FIXME: Not really tested.
         let name = NSWorkspace.accessibilityDisplayOptionsDidChangeNotification
         observers.append(NotificationObserver(name: name) { [weak self] _ in
            self?.notifySystemAppearanceDidChange()
         })
      }
      notifySystemAppearanceDidChange()
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   @available(OSX 10.14, *)
   override open func viewDidChangeEffectiveAppearance() {
      super.viewDidChangeEffectiveAppearance()
      notifySystemAppearanceDidChange()
   }

   override open func layout() {
      documentView?.setNeedsLayout() // Without this table view may not load and will be empty.
      super.layout()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}

extension ScrollView {

   private func setupNotifications() {
      observers.append(NotificationObserver(name: NSScrollView.willStartLiveScrollNotification, object: self) { [weak self] _ in
         self?.onWillStartLiveScroll?()
      })
      observers.append(NotificationObserver(name: NSScrollView.didLiveScrollNotification, object: self) { [weak self] _ in
         self?.onDidLiveScroll?()
      })
      observers.append(NotificationObserver(name: NSScrollView.didEndLiveScrollNotification, object: self) { [weak self] _ in
         self?.onDidEndLiveScroll?()
      })
   }

   private func notifySystemAppearanceDidChange() {
      setupAppearance(systemAppearance)
   }
}
#endif
