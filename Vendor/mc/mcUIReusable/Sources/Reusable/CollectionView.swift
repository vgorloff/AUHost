//
//  CollectionView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class CollectionView: UICollectionView {

   public init(layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
      super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
      translatesAutoresizingMaskIntoConstraints = false
      backgroundColor = .white
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayout() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDefaults() {
      // Base class does nothing.
   }
}
#endif
