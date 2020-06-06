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

   public func removeArrangedSubviews() {
      let views = arrangedSubviews
      views.forEach {
         removeArrangedSubview($0)
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
