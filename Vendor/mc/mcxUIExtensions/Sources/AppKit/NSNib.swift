//
//  NSNib.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

extension NSNib {

   public enum Error: Swift.Error {
      case unableToFindInstance(Any.Type)
   }

   public func instantiate(withOwner owner: Any?) -> [Any] {
      var topLevelObjects: NSArray?
      guard instantiate(withOwner: owner, topLevelObjects: &topLevelObjects) else {
         return []
      }
      let result = topLevelObjects as? [Any]
      return result ?? []
   }

   public func instantiateWithOwner<T>(_ ownerOrNil: Any?) throws -> T {
      let objects = instantiate(withOwner: ownerOrNil)
      for object in objects {
         if let resultObject = object as? T {
            return resultObject
         }
      }
      throw Error.unableToFindInstance(T.self)
   }
}
#endif
