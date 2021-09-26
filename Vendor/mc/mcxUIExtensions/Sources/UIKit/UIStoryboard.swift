//
//  UIStoryboard.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIStoryboard {

   public func instantiateViewController<T: UIViewController>(withID: String) -> T {
      let vc = instantiateViewController(withIdentifier: withID)
      if let vc = vc as? T {
         return vc
      } else {
         fatalError("Unexpected type: " + String(describing: vc))
      }
   }

   public func instantiateInitialViewController<T: UIViewController>() -> T {
      if let vc = instantiateInitialViewController() as? T {
         return vc
      } else {
         fatalError()
      }
   }
}
#endif
