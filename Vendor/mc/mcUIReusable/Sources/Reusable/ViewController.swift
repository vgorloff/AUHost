//
//  ViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 09.02.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

public class __ViewControllerContent: InstanceHolder<ViewController> {

   public var view: View {
      return instance.contentView
   }
}

open class ViewController: UIViewController {

   fileprivate let contentView: View
   private let layoutUntil = DispatchUntil()
   private let setupConstraintsOnce = DispatchOnce()

   #if os(iOS)
   private var supportedInterfaceOrientationsValue: UIInterfaceOrientationMask?

   override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
      return supportedInterfaceOrientationsValue ?? super.supportedInterfaceOrientations
   }
   #endif

   public var content: __ViewControllerContent {
      return __ViewControllerContent(instance: self)
   }

   override open func loadView() {
      super.loadView()
      view = contentView
      contentView.backgroundColor = .white
   }

   public init(view: View) {
      contentView = view
      super.init(nibName: nil, bundle: nil)
   }

   public init() {
      contentView = View()
      super.init(nibName: nil, bundle: nil)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   override open func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      onViewWillAppear(isAnimated: animated)
   }

   override open func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
      onViewDidAppear(isAnimated: animated)
      view.assertOnAmbiguityInSubviewsLayout()
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupDataSource()
      setupHandlers()
      setupDefaults()
      applyFixForUnsatisfiableConstraintsIfNeeded()
   }

   override open func viewWillLayoutSubviews() {
      super.viewWillLayoutSubviews()
      setupConstraintsOnce.perform {
         setupLayout()
      }
   }

   override open func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      // Below fix is disabled because it wasn't working on my side.
      // I ended up with UIBarButtonItem with custom view (UIButton) inside.
      // applyBarButtonsTintIssueFix()
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

   @objc open dynamic func setupDataSource() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayoutDefaults() {
      // Base class does nothing.
   }

   @objc open dynamic func onViewWillAppear(isAnimated: Bool) {
      // Base class does nothing.
   }

   @objc open dynamic func onViewDidAppear(isAnimated: Bool) {
      // Base class does nothing.
   }

   #if os(iOS)
   public final func setSupportedInterfaceOrientations(_ value: UIInterfaceOrientationMask?) {
      supportedInterfaceOrientationsValue = value
   }
   #endif
}

extension ViewController {

   private func applyFixForUnsatisfiableConstraintsIfNeeded() {
      let subviewsSizes = view.recursiveSubviews.map { $0.frame.size }.sorted { $0 < $1 }
      if let biggestSize = subviewsSizes.last, view.frame.size < biggestSize {
         view.frame = CGRect(origin: view.frame.origin, size: biggestSize)
      }
   }

   private func applyBarButtonsTintIssueFix() {
      // https://stackoverflow.com/a/48001648/1418981
      // Workaround for bug: UINavigationBar button remains faded after segue back.
      // Alternative solution: https://stackoverflow.com/a/47839657/1418981
      if #available(iOS 11.2, *) {
         navigationController?.navigationBar.tintAdjustmentMode = .normal
         navigationController?.navigationBar.tintAdjustmentMode = .automatic
      }
   }
}
#endif
