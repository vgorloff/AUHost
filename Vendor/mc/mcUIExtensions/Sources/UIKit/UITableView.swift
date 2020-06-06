//
//  UITableView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

extension UITableView {

   public convenience init(style: UITableView.Style) {
      self.init(frame: .zero, style: style)
   }

   public func performUpdates(commands: () -> Void) {
      performUpdates(commands: commands, completion: { _ in })
   }

   public func performUpdates(commands: () -> Void, completion: @escaping (Bool) -> Void) {
      if #available(iOS 11.0, tvOS 11.0, *) {
         performBatchUpdates(commands, completion: completion)
      } else {
         beginUpdates()
         commands()
         endUpdates()
         completion(true)
      }
   }

   public func setTableHeaderView(_ view: UIView?) {
      guard let view = view else {
         tableHeaderView = nil
         return
      }
      // See: https://stackoverflow.com/questions/16471846/is-it-possible-to-use-autolayout-with-uitableviews-tableheaderview
      tableHeaderView = view
      view.setNeedsLayout()
      view.layoutIfNeeded()
      let footerSize = view.systemLayoutSizeFitting(width: bounds.size.width, verticalFitting: .fittingSizeLevel)
      view.frame = CGRect(origin: view.frame.origin, size: footerSize)
      tableHeaderView = view
   }

   public func setTableFooterView(_ view: UIView?) {
      guard let view = view else {
         tableFooterView = nil
         return
      }
      // See: https://stackoverflow.com/questions/16471846/is-it-possible-to-use-autolayout-with-uitableviews-tableheaderview
      tableFooterView = view
      view.setNeedsLayout()
      view.layoutIfNeeded()
      let footerSize = view.systemLayoutSizeFitting(width: bounds.size.width, verticalFitting: .fittingSizeLevel)
      view.frame = CGRect(origin: view.frame.origin, size: footerSize)
      tableFooterView = view
   }

   public func selectAllRows(animated: Bool) {
      for section in 0 ..< numberOfSections {
         selectAllRows(inSection: section, animated: animated)
      }
   }

   public func deselectAllRows(animated: Bool) {
      for section in 0 ..< numberOfSections {
         deselectAllRows(inSection: section, animated: animated)
      }
   }

   public func selectAllRows(inSection section: Int, animated: Bool) {
      for row in 0 ..< numberOfRows(inSection: section) {
         let ip = IndexPath(row: row, section: section)
         selectRow(at: ip, animated: animated, scrollPosition: .none)
      }
   }

   public func deselectAllRows(inSection section: Int, animated: Bool) {
      for row in 0 ..< numberOfRows(inSection: section) {
         let ip = IndexPath(row: row, section: section)
         deselectRow(at: ip, animated: animated)
      }
   }
}

extension UITableView {

   public func setAutomaticRowHeight(estimatedHeight: CGFloat) {
      rowHeight = UITableView.automaticDimension
      estimatedRowHeight = estimatedHeight
   }

   public func setAutomaticSectionHeaderHeight(estimatedHeight: CGFloat) {
      sectionHeaderHeight = UITableView.automaticDimension
      estimatedSectionHeaderHeight = estimatedHeight
   }

   public func setAutomaticSectionFooterHeight(estimatedHeight: CGFloat) {
      sectionFooterHeight = UITableView.automaticDimension
      estimatedSectionFooterHeight = estimatedHeight
   }
}

extension UITableView {

   public func dequeueReusableCell(style: UITableViewCell.CellStyle) -> UITableViewCell {
      let reuseIdentifier = "cid:standard.\(style.stringValue)"
      if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) {
         return cell
      } else {
         return UITableViewCell(style: style, reuseIdentifier: reuseIdentifier)
      }
   }

   public func dequeueReusableCell<T: UITableViewCell>() -> T {
      let reuseIdentifier = T.reusableViewID
      if let cell = dequeueReusableCell(withIdentifier: reuseIdentifier) as? T {
         return cell
      } else {
         return T(style: .default, reuseIdentifier: reuseIdentifier)
      }
   }
}

extension UITableView {

   private struct Key {
      static var registeredTypes = "app.ui.registeredTypes"
   }

   private var registeredTypes: [String] {
      get {
         return ObjCAssociation.value(from: self, forKey: &Key.registeredTypes) ?? []
      } set {
         ObjCAssociation.setCopyNonAtomic(value: newValue, to: self, forKey: &Key.registeredTypes)
      }
   }

   public func dequeueReusableCell<T: UITableViewCell>(reusableType: T.Type = T.self, indexPath: IndexPath) -> T {
      let id = reusableType.reusableViewID
      var types = registeredTypes
      if !types.contains(id) {
         types.append(id)
         register(reusableType, forCellReuseIdentifier: id)
      }
      if let cell = dequeueReusableCell(withIdentifier: id, for: indexPath) as? T {
         return cell
      } else {
         fatalError("Cell with id \"\(id)\" of type \(T.self) seems not registered.")
      }
   }
}
#endif
