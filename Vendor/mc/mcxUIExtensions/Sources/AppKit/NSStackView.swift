//
//  NSStackView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSStackView {

   public var axis: NSUserInterfaceLayoutOrientation {
      get {
         return orientation
      } set {
         orientation = newValue
      }
   }

   public func addArrangedSubviews(_ views: NSView...) {
      addArrangedSubviews(views)
   }

   public func addArrangedSubviews(_ views: [NSView]) {
      for view in views {
         addArrangedSubview(view)
      }
   }

   public func setArrangedSubviews(_ views: NSView...) {
      setArrangedSubviews(views)
   }

   public func setArrangedSubviews(_ views: [NSView]) {
      removeArrangedSubviews()
      addArrangedSubviews(views)
   }

   public func removeArrangedSubviews() {
      let views = arrangedSubviews
      views.forEach {
         removeArrangedSubview($0)
         // See why this is needed: https://medium.com/inloopx/uistackview-lessons-learned-e5841205f650
         $0.removeFromSuperview()
      }
   }

   public func removeViews() {
      let items = views
      items.forEach {
         removeView($0)
      }
   }
}
#endif
