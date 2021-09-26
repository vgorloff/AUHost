//
//  TableHeaderFooterView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08/03/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class TableHeaderFooterView: UITableViewHeaderFooterView {

   public convenience init() {
      self.init(reuseIdentifier: nil)
   }

   override public init(reuseIdentifier: String?) {
      super.init(reuseIdentifier: reuseIdentifier)
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
