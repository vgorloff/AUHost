//
//  ScrollableContentViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 29.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import mcUI
import UIKit

open class ScrollableContentViewController<T: UIView>: UIViewController {

   public let contentView = T().autolayoutView()
   public let scrollView = ScrollView().autolayoutView()

   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      super.loadView()
      view = UIView()

      view.backgroundColor = .white
      scrollView.backgroundColor = .white
      contentView.backgroundColor = .white

      view.addSubview(scrollView)
      scrollView.addSubview(contentView)

      var constraints: [NSLayoutConstraint] = []
      constraints += anchor.withFormat("H:|[*]|", forEveryViewIn: contentView, scrollView)
      constraints += anchor.withFormat("V:|[*]|", forEveryViewIn: contentView, scrollView)
      constraints += [anchor.equalWidth(viewA: contentView, viewB: view)]
      NSLayoutConstraint.activate(constraints)
   }

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   override open func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
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
