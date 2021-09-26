//
//  NavigationItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.06.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcxTypes
import mcxUI

#if os(macOS)
import AppKit

public class NavigationItem {

   // Used only by `NavigationBar`
   var internalBackButtonTitle: String? {
      didSet {
         updateBackButtonTitle()
      }
   }

   var internalBackButtonIsHidden: Bool {
      get {
         return _backBarButtonItem.view.isHidden
      } set {
         _backBarButtonItem.view.isHidden = newValue
      }
   }

   private(set) var onBack = CompletionHandler()

   private(set) var view = NavigationItemView()
   private var _backBarButtonItem = BarButtonItem(title: "")

   public var title: String? {
      didSet {
         if let title = title {
            view.titleView = Label(title: title)
         } else {
            view.titleView = nil
         }
      }
   }

   init() {
      view.translatesAutoresizingMaskIntoConstraints = true
      view.autoresizingMask = [.width, .height]
      updateBackButtonTitle()
      _backBarButtonItem.setHandler(self) {
         $0.onBack.fire()
      }
      view.stackViewLeft.addArrangedSubview(_backBarButtonItem.view)
   }

   public var leftBarButtonItems: [BarButtonItem]? {
      didSet {
         updateLeftItems()
      }
   }

   public var rightBarButtonItems: [BarButtonItem]? {
      didSet {
         view.stackViewRight.removeArrangedSubviews()
         view.stackViewRight.addArrangedSubviews((rightBarButtonItems ?? []).map { $0.view })
      }
   }

   public var leftItemsSupplementBackButton: Bool = false {
      didSet {
         updateLeftItems()
      }
   }

   private func updateBackButtonTitle() {
      _backBarButtonItem.title = "< " + (internalBackButtonTitle ?? "Back")
   }

   private func updateLeftItems() {
      view.stackViewLeft.removeArrangedSubviews()
      view.stackViewLeft.addArrangedSubviews((leftBarButtonItems ?? []).map { $0.view })
      if leftItemsSupplementBackButton {
         view.stackViewLeft.insertArrangedSubview(_backBarButtonItem.view, at: 0)
      }
   }
}

class NavigationItemView: View {

   fileprivate lazy var stackViewLeft = StackView()
   fileprivate var titleView: NSView? {
      didSet {
         stackViewMiddle.removeArrangedSubviews()
         if let titleView = titleView {
            stackViewMiddle.addArrangedSubview(titleView)
         }
      }
   }

   fileprivate lazy var stackViewMiddle = StackView()
   fileprivate lazy var stackViewRight = StackView()

   override func setupUI() {
      addSubviews(stackViewLeft, stackViewMiddle, stackViewRight)
      stackViewLeft.alignment = .centerY
      stackViewRight.alignment = .centerY
      stackViewMiddle.alignment = .centerY
      stackViewLeft.spacing = 8
      stackViewRight.spacing = 8
      stackViewMiddle.spacing = 8
      wantsLayer = true
   }

   override func setupLayout() {
      anchor.pin.vertically(stackViewLeft, stackViewMiddle, stackViewRight).activate()
      anchor.withFormat("|-8-[*]-(>=8)-[*]-(>=8)-[*]-8-|", stackViewLeft, stackViewMiddle, stackViewRight).activate()
      anchor.center.x(stackViewMiddle).activate()
   }
}

#endif
