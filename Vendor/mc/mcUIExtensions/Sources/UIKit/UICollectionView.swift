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
    }

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

      func registerClassOrNib() {
          let nibName = NSStringFromClass(type).components(separatedBy: ".").last ?? ""
          let bundle = Bundle(for: type)
          if bundle.url(forResource: nibName, withExtension: "nib") != nil {
              let nib = UINib(nibName: nibName, bundle: bundle)
              register(nib, forCellWithReuseIdentifier: id)
          } else {
              register(type, forCellWithReuseIdentifier: id)
          }
      }

      let id = type.reusableViewID
      var types = registeredTypes
      if !types.contains(id) {
         types.append(id)
         registeredTypes = types
         registerClassOrNib()
      }
      if let cell = dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as? T {
         return cell
      } else {
         fatalError("Cell with id \"\(id)\" of type \(T.self) seems not registered.")
      }
   }
}
#endif
