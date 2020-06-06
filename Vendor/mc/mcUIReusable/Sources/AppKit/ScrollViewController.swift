//
//  ScrollViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcUI
import mcUIExtensions

open class ScrollViewController: ViewController {

   public let scrollView: ScrollView

   public init(documentView: NSView) {
      scrollView = ScrollView(document: documentView).autolayoutView()
      scrollView.borderType = .noBorder
      scrollView.backgroundColor = .clear
      scrollView.drawsBackground = false
      super.init()
   }

   override open func viewDidLoad() {
      content.view.addSubview(scrollView)
      anchor.withFormat("|[*]|", scrollView).activate()
      anchor.withFormat("V:|[*]|", scrollView).activate()
      super.viewDidLoad()
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }
}
#endif
