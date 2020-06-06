//
//  StackViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 19.03.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

open class StackViewController: ViewController {

   public private(set) lazy var stackView = UIStackView().autolayoutView()

   override open func loadView() {
      view = UIView()
      view.backgroundColor = .white
      view.addSubview(stackView)

      stackView.axis = .vertical
      stackView.spacing = 8
      stackView.isLayoutMarginsRelativeArrangement = true
      stackView.layoutMargins = UIEdgeInsets(horizontal: 15, vertical: 15)

      if #available(iOS 11.0, tvOS 11.0, *) {
         view.safeAreaLayoutGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
         view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
         view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
         view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
      } else {
         view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
         view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
         topLayoutGuide.bottomAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
         bottomLayoutGuide.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
      }
   }
}
#endif
