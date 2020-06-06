//
//  ReusableView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public protocol ReusableView: class {
   #if os(iOS) || os(tvOS)
   static var reusableViewID: String { get }
   #elseif os(OSX)
   static var reusableViewID: NSUserInterfaceItemIdentifier { get }
   #endif
}

extension ReusableView {
   #if os(iOS) || os(tvOS)
   public static var reusableViewID: String {
      let id = "vid:" + NSStringFromClass(self)
      return id
   }

   #elseif os(OSX)
   public static var reusableViewID: NSUserInterfaceItemIdentifier {
      let id = "vid:" + NSStringFromClass(self)
      return NSUserInterfaceItemIdentifier(rawValue: id)
   }
   #endif
}

#if os(iOS) || os(tvOS)

extension UIView: ReusableView {
}

extension UITableView {

   public func register(cells: ReusableView.Type...) {
      for type in cells {
         register(type, forCellReuseIdentifier: type.reusableViewID)
      }
   }

   public func register(cells: [ReusableView.Type]) {
      for type in cells {
         register(type, forCellReuseIdentifier: type.reusableViewID)
      }
   }

   public func register(headersFooters: [ReusableView.Type]) {
      for type in headersFooters {
         register(type, forHeaderFooterViewReuseIdentifier: type.reusableViewID)
      }
   }
}

extension UICollectionView {

   public func register(cells: ReusableView.Type...) {
      for type in cells {
         register(type, forCellWithReuseIdentifier: type.reusableViewID)
      }
   }

   public func register(cells: [ReusableView.Type]) {
      for type in cells {
         register(type, forCellWithReuseIdentifier: type.reusableViewID)
      }
   }
}

#elseif os(OSX)

extension NSView: ReusableView {
}

extension NSTableView {

   public func makeView<T: NSView>(_: T.Type, reusableID: NSUserInterfaceItemIdentifier = T.reusableViewID) -> T {
      if let view = makeView(withIdentifier: reusableID, owner: nil) as? T {
         return view
      } else {
         let view = T()
         view.identifier = reusableID
         return view
      }
   }
}
#endif
