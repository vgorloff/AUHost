//
//  TableView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class TableView: UITableView {

   override public init(frame: CGRect, style: UITableView.Style) {
      super.init(frame: frame, style: style)
      translatesAutoresizingMaskIntoConstraints = false
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   override open func awakeFromNib() {
      super.awakeFromNib()
      translatesAutoresizingMaskIntoConstraints = true
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
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
