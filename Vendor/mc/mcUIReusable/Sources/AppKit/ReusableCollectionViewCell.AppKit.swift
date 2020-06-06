//
//  ReusableCollectionViewCell.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 05.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

public class ReusableCollectionViewCell<T: NSView>: NSCollectionViewItem {

   public let contentView = T()
   private let layoutUntil = DispatchUntil()

   override open func loadView() {
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

extension NSCollectionView {

   public func dequeueReusableCell<T: NSView>(indexPath: IndexPath, reuseIdentifier: NSUserInterfaceItemIdentifier = T.reusableViewID) -> ReusableCollectionViewCell<T> {
      if let item = makeItem(withIdentifier: reuseIdentifier, for: indexPath) as? ReusableCollectionViewCell<T> {
         return item
      } else {
         fatalError()
      }
   }

   public func registerReusableCell<T: NSView>(_: T.Type) {
      register(ReusableCollectionViewCell<T>.self, forItemWithIdentifier: T.reusableViewID)
   }
}
#endif
