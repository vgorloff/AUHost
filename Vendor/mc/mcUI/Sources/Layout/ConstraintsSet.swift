//
//  ConstraintsSet.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 14.10.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct ConstraintsSet {

   #if os(iOS) || os(tvOS)
   public typealias ViewType = UIView
   public typealias EdgeInsets = UIEdgeInsets
   #elseif os(OSX)
   public typealias ViewType = NSView
   public typealias EdgeInsets = NSEdgeInsets
   #endif

   public class AllEdges {

      public let top: NSLayoutConstraint
      public let bottom: NSLayoutConstraint
      public let leading: NSLayoutConstraint
      public let trailing: NSLayoutConstraint

      public init(view: ViewType, container: ViewType) {
         leading = view.leadingAnchor.constraint(equalTo: container.leadingAnchor)
         trailing = container.trailingAnchor.constraint(equalTo: view.trailingAnchor)
         top = view.topAnchor.constraint(equalTo: container.topAnchor)
         bottom = container.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      }

      public func configure(insets: EdgeInsets) {
         top.constant = insets.top
         bottom.constant = insets.bottom
         leading.constant = insets.left
         trailing.constant = insets.right
      }

      public func activate() {
         [top, bottom, leading, trailing].activate()
      }

      public func deactivate() {
         [top, bottom, leading, trailing].deactivate()
      }
   }
}
