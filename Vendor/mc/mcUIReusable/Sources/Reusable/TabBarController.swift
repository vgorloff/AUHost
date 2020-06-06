//
//  TabBarController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 19.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import UIKit

open class TabBarController: UITabBarController {

   private let layoutUntil = DispatchUntil()

   override open func loadView() {
      super.loadView()
      view.backgroundColor = .white
   }

   override open func viewDidLayoutSubviews() {
      super.viewDidLayoutSubviews()
      layoutUntil.performIfNeeded {
         setupLayoutDefaults()
      }
   }

   override open func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      layoutUntil.fulfill()
      handleDidAppear()
   }

   override open func viewDidLoad() {
      super.viewDidLoad()
      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   open func setupUI() {
   }

   open func setupLayout() {
   }

   open func setupHandlers() {
   }

   open func setupDefaults() {
   }

   open func setupLayoutDefaults() {
   }

   open func handleDidAppear() {
   }
}
#endif
