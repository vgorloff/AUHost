//
//  TableViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 13.03.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

open class TableViewController: UITableViewController {

   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      super.loadView()
      view.backgroundColor = .white
   }

   public init() {
      super.init(nibName: nil, bundle: nil)
   }

   override public init(style: UITableView.Style) {
      super.init(style: style)
   }

   public required init?(coder: NSCoder) {
      super.init(coder: coder)
   }

   override open func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      applyFixForNotUpToDateViewFrameIfNeeded(view: tableView.tableHeaderView)
      applyFixForNotUpToDateViewFrameIfNeeded(view: tableView.tableFooterView)
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   override open func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
      handleViewDidAppear(isAnimated: animated)
      view.assertOnAmbiguityInSubviewsLayout()
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      #if os(iOS)
      if ProcessInfo.processInfo.operatingSystemVersion.majorVersion < 11 {
         // Fixes for broken layout on iPad.
         tableView.setAutomaticRowHeight(estimatedHeight: 64)
      }
      #endif
      setupUI()
      setupLayout()
      setupHandlers()
      setupDataSource()
      setupDefaults()
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

   @objc open dynamic func handleViewDidAppear(isAnimated: Bool) {
   }
}

extension TableViewController {

   // See: https://stackoverflow.com/questions/16471846/is-it-possible-to-use-autolayout-with-uitableviews-tableheaderview
   // See: `UITableView.setTableFooterView` in our codebase.
   private func applyFixForNotUpToDateViewFrameIfNeeded(view: UIView?) {
      guard let view = view else { return }

      let width = tableView.bounds.width
      let size = view.systemLayoutSizeFitting(width: width, verticalFitting: .fittingSizeLevel)
      let frame = CGRect(x: 0, y: view.frame.origin.y, width: width, height: size.height)
      if view.frame != frame {
         view.frame = frame
      }
   }
}
#endif
