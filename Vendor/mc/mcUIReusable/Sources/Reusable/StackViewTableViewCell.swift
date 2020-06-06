//
//  StackViewTableViewCell.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.04.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcUIExtensions
import UIKit

open class StackViewTableViewCell: UITableViewCell {

   public private(set) lazy var stackView = StackView().autolayoutView()

   override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      contentView.addSubview(stackView)
      let constraints = [stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
                         stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                         stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                         stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)]
      NSLayoutConstraint.activate(constraints)
      setupUI()
      setupLayout()
      setupHandlers()
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   open func setupUI() {
      // Base class does nothing
   }

   open func setupLayout() {
      // Base class does nothing
   }

   open func setupHandlers() {
      // Base class does nothing
   }
}
#endif
