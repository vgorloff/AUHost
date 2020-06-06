//
//  CollectionViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.04.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import Foundation
import mcTypes
import UIKit

open class CollectionViewController: UICollectionViewController {

   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      super.loadView()
      collectionView.backgroundColor = .white
   }

   public init() {
      super.init(collectionViewLayout: UICollectionViewFlowLayout())
   }

   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupLayout()
      setupHandlers()
      setupDataSource()
      setupDefaults()
   }

   override open func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   override open func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDataSource() {
   }

   @objc open dynamic func setupDefaults() {
   }

   @objc open dynamic func setupLayoutDefaults() {
   }
}
#endif
