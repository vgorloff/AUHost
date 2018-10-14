//
//  StackViewController.swift
//  WLUI
//
//  Created by Vlad Gorlov on 03.05.18.
//  Copyright © 2018 Demo. All rights reserved.
//

import AppKit

open class StackViewController: ViewController {

   public private(set) lazy var stackView = StackView().autolayoutView()

   open override func loadView() {
      super.loadView()
      contentView.addSubview(stackView)

      stackView.orientation = .vertical
      stackView.spacing = 8
      stackView.edgeInsets = NSEdgeInsets(horizontal: 8, vertical: 8)

      LayoutConstraint.withFormat("|[*]|", stackView).activate()
      LayoutConstraint.withFormat("V:|[*]|", stackView).activate()
   }
}
