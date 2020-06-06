//
//  ReusableScene.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import UIKit

open class ReusableScene: UIView, ReusableContentView {

   public private(set) weak var controller: UIViewController?

   open func willAppear(_: Bool) {}

   open func didAppear(_: Bool) {}

   open func willDisappear(_: Bool) {}

   open func didDisappear(_: Bool) {}

   override public init(frame: CGRect) {
      super.init(frame: frame)
      translatesAutoresizingMaskIntoConstraints = false
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   public func setController(_ controller: UIViewController?) {
      self.controller = controller
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public var navigationItem: UINavigationItem? {
      return controller?.navigationItem
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
