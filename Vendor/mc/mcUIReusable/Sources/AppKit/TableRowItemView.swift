//
//  TableRowItemView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.09.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class TableRowItemView: View {

   public private(set) var isSelected: Bool = false

   @objc open dynamic func setSelected(_ isSelected: Bool) {
      self.isSelected = isSelected
   }

   override public init() {
      super.init()
      setSelected(false)
   }

   public required init?(coder decoder: NSCoder) {
      fatalError()
   }
}
#endif
