//
//  CollectionViewItem.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes
import mcUI

open class CollectionViewItem: NSCollectionViewItem {

   public let contentView = View()
   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      contentView.onAppearanceDidChanged = { [weak self] in
         self?.setupAppearance($0)
      }
      view = contentView
   }

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   override public init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
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
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupAppearance(contentView.systemAppearance)
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

   @objc open dynamic func setupAppearance(_: SystemAppearance) {
   }
}
#endif
