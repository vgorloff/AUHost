//
//  NSViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 28.05.20.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import mcTypes

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public class NSViewControllerAsObservable: InstanceHolder<NSViewController> {

   public var disposeBag: DisposeBag {
      return instance.disposeBag
   }
}

extension NSViewController {

   private struct Key {
      static var disposeBag = "app.ui.disposeBag"
   }

   fileprivate var disposeBag: DisposeBag {
      get {
         if let value: DisposeBag = ObjCAssociation.value(from: self, forKey: &Key.disposeBag) {
            return value
         } else {
            let bag = DisposeBag()
            ObjCAssociation.setRetainNonAtomic(value: bag, to: self, forKey: &Key.disposeBag)
            return bag
         }
      } set {
         ObjCAssociation.setRetainNonAtomic(value: newValue, to: self, forKey: &Key.disposeBag)
      }
   }

   public var asObservable: NSViewControllerAsObservable {
      return NSViewControllerAsObservable(instance: self)
   }
}
#endif
