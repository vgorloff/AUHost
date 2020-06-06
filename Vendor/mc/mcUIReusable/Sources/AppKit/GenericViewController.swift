//
//  GenericViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

open class GenericViewController<T: NSView>: NSViewController {

   public let contentView = T()
   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      view = contentView
   }

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
      setupDatasource()
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

   open func setupDatasource() {
   }

   open func setupLayoutDefaults() {
   }
}
#endif
