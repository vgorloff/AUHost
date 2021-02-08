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
import mcTypes

public class __SplitViewControllerContent: InstanceHolder<SplitViewController> {

   public var view: View {
      return instance._view
   }

   public var splitView: SplitView {
      return instance._splitView
   }
}

open class SplitViewController: NSSplitViewController {

   fileprivate lazy var _splitView = SplitView()
   fileprivate lazy var _view = View().autoresizingView()

   public var content: __SplitViewControllerContent {
      return __SplitViewControllerContent(instance: self)
   }

   override open func loadView() {
      _splitView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
      _view.addSubview(_splitView)
      splitView = _splitView
      view = _view
      anchor.pin.toBounds(_splitView).activate()
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
      setupAppearance(content.splitView.systemAppearance)
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}
#endif
