//
//  SplitViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcUI

open class SplitViewController: NSSplitViewController {

   public private(set) lazy var contentView = SplitView().autolayoutView()

   override open func loadView() {
      contentView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
      let view = View()
      view.addSubview(contentView)
      splitView = contentView
      self.view = view
      anchor.pin.toBounds(splitView).activate()
   }

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupAppearance(contentView.systemAppearance)
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   open func setupUI() {
   }

   open func setupLayout() {
   }

   open func setupHandlers() {
   }

   open func setupDefaults() {
   }

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}
#endif
