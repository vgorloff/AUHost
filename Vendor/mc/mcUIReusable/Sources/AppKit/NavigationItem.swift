//
//  NavigationItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 01.06.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes
import mcUI

#if os(macOS)

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
   fileprivate lazy var stackViewRight = StackView()

   override func setupUI() {
      addSubviews(stackViewLeft, stackViewRight)
      stackViewLeft.alignment = .centerY
      stackViewRight.alignment = .centerY
      stackViewLeft.spacing = 8
      stackViewRight.spacing = 8
      wantsLayer = true
   }

   override func setupLayout() {
      anchor.pin.vertically(stackViewLeft, stackViewRight).activate()
      anchor.withFormat("|-8-[*]-(>=8)-[*]-8-|", stackViewLeft, stackViewRight).activate()
   }
}

#endif
