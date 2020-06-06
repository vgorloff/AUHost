//
//  TabViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

open class TabViewController: NSTabViewController {

   private let layoutUntil = DispatchUntil()

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func viewDidLayout() {
      super.viewDidLayout()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   override open func viewDidAppear() {
      super.viewDidAppear()
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
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
}
#endif
