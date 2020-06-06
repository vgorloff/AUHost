//
//  StackViewController.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcUI

open class StackViewController: ViewController {

   public private(set) lazy var stackView = StackView().autolayoutView()

   override open func loadView() {
      super.loadView()
      content.view.addSubview(stackView)

      stackView.orientation = .vertical
      stackView.spacing = 8
      stackView.edgeInsets = NSEdgeInsets(horizontal: 8, vertical: 8)

      anchor.withFormat("|[*]|", stackView).activate()
      anchor.withFormat("V:|[*]|", stackView).activate()
   }
}
#endif
