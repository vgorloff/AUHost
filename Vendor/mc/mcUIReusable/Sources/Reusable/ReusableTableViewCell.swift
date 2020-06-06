//
//  ReusableTableViewCell.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcUI
import UIKit

public class ReusableTableViewCell<T: UIView>: UITableViewCell {

   public let view: T

   public init(view: T = T(), reuseIdentifier: String = T.reusableViewID, pinToMargins: Bool = false) {
      self.view = view.autolayoutView()
      super.init(style: .default, reuseIdentifier: reuseIdentifier)
      contentView.addSubview(view)
      if pinToMargins {
         anchor.withFormat("|-[*]-|", view).activate()
         // Without `priority` embeded stack view may have broken layout. Seems Apple bug.
         anchor.withFormat("V:|-[*]-|", view).activate(priority: UILayoutPriority(rawValue: 999))
      } else {
         anchor.withFormat("|[*]|", view).activate()
         // Without `priority` embeded stack view may have broken layout. Seems Apple bug.
         anchor.withFormat("V:|[*]|", view).activate(priority: UILayoutPriority(rawValue: 999))
      }
   }

   public init(view: T = T(), reuseIdentifier: String = T.reusableViewID, margins: UIEdgeInsets) {
      self.view = view.autolayoutView()
      super.init(style: .default, reuseIdentifier: reuseIdentifier)
      contentView.addSubview(view)
      preservesSuperviewLayoutMargins = false
      contentView.preservesSuperviewLayoutMargins = false
      contentView.layoutMargins = margins
      anchor.withFormat("|-[*]-|", view).activate()
      // Without `priority` embeded stack view may have broken layout. Seems Apple bug.
      anchor.withFormat("V:|-[*]-|", view).activate(priority: UILayoutPriority(rawValue: 999))
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   override public func prepareForReuse() {
      super.prepareForReuse()
      if let view = view as? ReusableCellContentView {
         view.prepareForReuse()
      }
   }
}

extension UITableView {

   public func dequeueReusableCell<T: UIView>(_ viewType: T.Type, margins: UIEdgeInsets) -> ReusableTableViewCell<T> {
      let reuseIdentifier = viewType.reusableViewID
      if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? ReusableTableViewCell<T> {
         return cell
      } else {
         return ReusableTableViewCell(reuseIdentifier: reuseIdentifier, margins: margins)
      }
   }

   public func dequeueReusableCell<T: UIView>(_ viewType: T.Type, pinToMargins: Bool = false) -> ReusableTableViewCell<T> {
      let reuseIdentifier = viewType.reusableViewID
      if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? ReusableTableViewCell<T> {
         return cell
      } else {
         return ReusableTableViewCell(reuseIdentifier: reuseIdentifier, pinToMargins: pinToMargins)
      }
   }

   public func dequeueReusableCell<T: UIView>(reuseIdentifier: String = T.reusableViewID,
                                              pinToMargins: Bool = false) -> ReusableTableViewCell<T> {
      if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? ReusableTableViewCell<T> {
         return cell
      } else {
         return ReusableTableViewCell(reuseIdentifier: reuseIdentifier, pinToMargins: pinToMargins)
      }
   }

   public func dequeueContainerCell<T: UIView>(view: T, pinToMargins: Bool = false) -> ReusableTableViewCell<T> {
      let reuseIdentifier = T.reusableViewID
      if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? ReusableTableViewCell<T> {
         return cell
      } else {
         return ReusableTableViewCell(view: view, reuseIdentifier: reuseIdentifier, pinToMargins: pinToMargins)
      }
   }
}
#endif
