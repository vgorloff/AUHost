//
//  UICollectionView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcxTypes
import mcxUI
import UIKit

extension UICollectionView {

   public func registerCell<T: UICollectionViewCell>(_ type: T.Type, id: String? = nil) {
      let id = id ?? type.reusableViewID
      let nibName = NSStringFromClass(type).components(separatedBy: ".").last ?? ""
      let bundle = Bundle(for: type)
      if bundle.url(forResource: nibName, withExtension: "nib") != nil {
         let nib = UINib(nibName: nibName, bundle: bundle)
         register(nib, forCellWithReuseIdentifier: id)
      } else {
         register(type, forCellWithReuseIdentifier: id)
      }
      var types = registeredTypes
      types.append(id)
      registeredTypes = types
   }

   public func registerSupplementaryView<T: UICollectionReusableView>(_ type: T.Type, kind: String, id: String? = nil) {
      let id = id ?? type.reusableViewID
      let nibName = NSStringFromClass(type).components(separatedBy: ".").last ?? ""
      let bundle = Bundle(for: type)
      if bundle.url(forResource: nibName, withExtension: "nib") != nil {
         let nib = UINib(nibName: nibName, bundle: bundle)
         register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: id)
      } else {
         register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: id)
      }
      var types = registeredSupplementaryTypes
      types.append(id)
      registeredSupplementaryTypes = types
   }

   private enum Key {
      static var registeredTypes = "app.ui.registeredTypes"
      static var registeredSupplementaryTypes = "app.ui.registeredSupplementaryTypes"
   }

   private var registeredTypes: [String] {
      get {
         return ObjCAssociation.value(from: self, forKey: &Key.registeredTypes) ?? []
      } set {
         ObjCAssociation.setCopyNonAtomic(value: newValue, to: self, forKey: &Key.registeredTypes)
      }
   }

   private var registeredSupplementaryTypes: [String] {
       get {
           return ObjCAssociation.value(from: self, forKey: &Key.registeredSupplementaryTypes) ?? []
       } set {
           ObjCAssociation.setCopyNonAtomic(value: newValue, to: self, forKey: &Key.registeredSupplementaryTypes)
       }
   }

   /// Dequeues reusable cell with type autoregistration.
   public func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
      let id = type.reusableViewID
      if !registeredTypes.contains(id) {
          registerCell(type, id: id)
      }
      if let cell = dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T {
         return cell
      } else {
         fatalError("Cell with id \"\(id)\" of type \(T.self) seems not registered.")
      }
   }

   /// Dequeues reusable view with type autoregistration.
   public func dequeueReusableSupplementaryView<T: UICollectionReusableView>(type: T.Type, kind: String, indexPath: IndexPath) -> T {
      let id = type.reusableViewID
       if !registeredSupplementaryTypes.contains(id) {
           registerSupplementaryView(type, kind: kind, id: id)
       }
       if let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as? T {
           return view
       } else {
           fatalError("View with id \"\(id)\" of type \(T.self) seems not registered.")
       }
   }
}
#endif
