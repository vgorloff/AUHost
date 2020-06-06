//
//  TableViewController.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 15.07.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcTypes

open class TableViewController: NSViewController {

   public let tableView: NSTableView
   public private(set) lazy var scrollView = ScrollView(document: tableView).autolayoutView()
   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      view = scrollView
   }

   public init() {
      tableView = TableView()
      super.init(nibName: nil, bundle: nil)
   }

   public init(tableView: NSTableView) {
      self.tableView = tableView
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func viewDidLayout() {
      super.viewDidLayout()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   override open func viewDidAppear() {
      super.viewDidAppear()
      layoutUntil.fulfill()
      view.assertOnAmbiguityInSubviewsLayout()
   }

   override open func viewDidLoad() {
      super.viewDidLoad()

      scrollView.hasVerticalScroller = true

      // Lifecycle
      setupUI()
      setupLayout()
      setupDatasource()
      setupHandlers()
      setupDefaults()

      tableView.reloadData()
   }

   @objc open dynamic func setupUI() {
   }

   @objc open dynamic func setupLayout() {
   }

   @objc open dynamic func setupHandlers() {
   }

   @objc open dynamic func setupDefaults() {
   }

   @objc open dynamic func setupDatasource() {
   }

   @objc open dynamic func setupLayoutDefaults() {
   }
}
#endif
