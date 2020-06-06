//
//  CollectionReusableView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class CollectionReusableView: UICollectionReusableView {

   override public init(frame: CGRect) {
      super.init(frame: frame)
      initializeView()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   /// Called after all KVC properties are settled.
   open func initializeView() {
      // Do something
   }
}
#endif
