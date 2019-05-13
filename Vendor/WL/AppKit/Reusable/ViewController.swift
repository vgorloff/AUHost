//
//  ViewController.swift
//  WLUI
//
//  Created by Vlad Gorlov on 03.02.18.
//  Copyright © 2018 Demo. All rights reserved.
//

import AppKit
import mcFoundation
import mcUI

open class ViewController: NSViewController {

   public let contentView: View
   private let layoutUntil = DispatchUntil()

   open override func loadView() {
      view = contentView
   }

   public init() {
      contentView = View()
      super.init(nibName: nil, bundle: nil)
      contentView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
   }

   public init(view: View) {
      contentView = view
      super.init(nibName: nil, bundle: nil)
      contentView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   open override func viewDidLayout() {
      super.viewDidLayout()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   open override func viewDidAppear() {
      super.viewDidAppear()
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   open override func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupAppearance(contentView.systemAppearance)
      setupLayout()
      setupDataSource()
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

   @objc open dynamic func setupDataSource() {
   }

   @objc open dynamic func setupLayoutDefaults() {
   }

   @objc open dynamic func setupAppearance(_ appearance: SystemAppearance) {
   }
}
