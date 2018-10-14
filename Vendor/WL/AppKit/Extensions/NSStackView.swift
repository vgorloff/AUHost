//
//  NSStackView.swift
//  mcLib-macOS
//
//  Created by Vlad Gorlov on 10.06.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

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
