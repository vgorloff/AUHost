//
//  ReusableViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import UIKit

public protocol ReusableContentView: UIView {

   func willAppear(_ animated: Bool)
   func didAppear(_ animated: Bool)
   func willDisappear(_ animated: Bool)
   func didDisappear(_ animated: Bool)
   func setController(_ controller: UIViewController?)
}

extension ReusableContentView {

   public func willAppear(_: Bool) {}
   public func didAppear(_: Bool) {}
   public func willDisappear(_: Bool) {}
   public func didDisappear(_: Bool) {}
   public func setController(_: UIViewController?) {}
}

public class ReusableViewController<T: ReusableContentView>: UIViewController {

   public let scene: T

   public init(view: T) {
      scene = view
      super.init(nibName: nil, bundle: nil)
      scene.setController(self)
   }

   public init() {
      scene = T(frame: CGRect(width: 320, height: 480))
      super.init(nibName: nil, bundle: nil)
      scene.setController(self)
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func loadView() {
      super.loadView()
      scene.translatesAutoresizingMaskIntoConstraints = true
      view = scene
      if scene.backgroundColor == nil {
         scene.backgroundColor = .white
      }
   }

   override open func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      scene.willAppear(animated)
   }

   override open func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      scene.didAppear(animated)
   }

   override open func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      scene.willDisappear(animated)
   }

   override public func viewDidDisappear(_ animated: Bool) {
      super.viewDidDisappear(animated)
      scene.didDisappear(animated)
   }
}
#endif
