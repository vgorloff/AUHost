//
//  VisualEffectView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 19.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class VisualEffectView: UIVisualEffectView {

   override public init(effect: UIVisualEffect?) {
      super.init(effect: effect)
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   open func setupUI() {
      // Do something
   }

   open func setupLayout() {
      // Do something
   }

   open func setupHandlers() {
      // Do something
   }

   open func setupDefaults() {
      // Do something
   }
}
#endif
