//
//  UINib.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UINib {

   public enum Error: Swift.Error {
      case unableToFindInstance(Any.Type)
   }

   public convenience init(forClass: AnyClass) {
      let name = NSStringFromClass(forClass).components(separatedBy: ".").last!
      let bundle = Bundle(for: forClass)
      self.init(nibName: name, bundle: bundle)
   }

   public func instantiateWithOwner<T>(_ ownerOrNil: Any?, optionsOrNil: [UINib.OptionsKey: Any]? = nil) throws -> T {
      let objects = instantiate(withOwner: ownerOrNil, options: optionsOrNil)
      for object in objects {
         if let resultObject = object as? T {
            return resultObject
         }
      }
      throw Error.unableToFindInstance(T.self)
   }
}
#endif
