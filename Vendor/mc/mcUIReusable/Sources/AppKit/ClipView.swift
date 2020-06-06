//
//  ClipView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcFoundationObservables

open class ClipView: NSClipView {

   public var onBoundsDidChange: ((NSClipView) -> Void)? {
      didSet {
         setupBoundsChangeObserver()
      }
   }

   private var boundsChangeObserver: NotificationObserver?

   private var mIsFlipped: Bool?

   override open var isFlipped: Bool {
      return mIsFlipped ?? super.isFlipped
   }

   // MARK: -

   public func setIsFlipped(_ value: Bool?) {
      mIsFlipped = value
   }

   open func scroll(_ point: NSPoint, shouldNotifyBoundsChange: Bool) {
      if shouldNotifyBoundsChange {
         scroll(to: point)
      } else {
         boundsChangeObserver?.isActive = false
         scroll(to: point)
         boundsChangeObserver?.isActive = true
      }
   }

   // MARK: - Private

   private func setupBoundsChangeObserver() {
      postsBoundsChangedNotifications = onBoundsDidChange != nil
      boundsChangeObserver = nil
      if postsBoundsChangedNotifications {
         boundsChangeObserver = NotificationObserver(name: NSView.boundsDidChangeNotification, object: self) { [weak self] _ in
            guard let this = self else { return }
            self?.onBoundsDidChange?(this)
         }
      }
   }
}
#endif
