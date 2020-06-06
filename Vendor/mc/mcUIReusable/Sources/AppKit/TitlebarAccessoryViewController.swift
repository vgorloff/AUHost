//
//  TitlebarAccessoryViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

open class TitlebarAccessoryViewController: NSTitlebarAccessoryViewController {

   public let contentView: View
   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      view = contentView
   }

   public init() {
      contentView = View()
      super.init(nibName: nil, bundle: nil)
   }

   public init(view: View) {
      contentView = view
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

   @objc open dynamic func setupLayoutDefaults() {
   }
}
#endif
