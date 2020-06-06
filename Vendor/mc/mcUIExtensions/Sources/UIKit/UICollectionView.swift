//
//  UICollectionView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcTypes
import mcUI
import UIKit

extension UICollectionView {

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

   /// Dequeues reusable cell with type autoregistration.
   public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
      let id = type.reusableViewID
      var types = registeredTypes
      if !types.contains(id) {
         types.append(id)
         registeredTypes = types
         register(type, forCellWithReuseIdentifier: id)
      }
      if let cell = dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T {
         return cell
      } else {
         fatalError("Cell with id \"\(id)\" of type \(T.self) seems not registered.")
      }
   }
}
#endif
