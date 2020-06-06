//
//  NSScrollView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcUI

extension NSScrollView {

   public convenience init(vertivallyScrollableDocument: NSView) {
      self.init(document: vertivallyScrollableDocument)
      hasVerticalScroller = true
   }

   public convenience init(document view: NSView) {
      let frame = CGRect(dimension: 10) // Some dummy non zero value
      self.init(frame: frame)
      if view is NSTextView || view is NSTableView || view is NSCollectionView {
         setup(mode: .byUsingAutoresizingMask, view: view)
      } else {
         setup(mode: .byUsingAutolayout, view: view)
      }
   }
}

extension NSScrollView {

   enum Mode: Int {
      case byUsingAutoresizingMask, byUsingAutolayout
   }

   func setup(mode: Mode, view: NSView) {
      let clipView = ClipView(frame: frame)
      clipView.documentView = view
      clipView.autoresizingMask = [.height, .width]
      clipView.setIsFlipped(true)
      contentView = clipView
      view.frame = frame
      switch mode {
      case .byUsingAutoresizingMask:
         view.translatesAutoresizingMaskIntoConstraints = true
         view.autoresizingMask = [.width, .height]
      case .byUsingAutolayout:
         view.translatesAutoresizingMaskIntoConstraints = false
         anchor.pin.horizontally(view).activate()
         view.topAnchor.constraint(equalTo: clipView.topAnchor).activate()
      }
   }
}
#endif
