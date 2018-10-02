//
//  ObjCAssociation.swift
//  mcCore
//
//  Created by Vlad Gorlov on 03.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import ObjectiveC

public struct ObjCAssociation {

   public static func value<T>(from object: AnyObject, forKey key: UnsafeRawPointer) -> T? {
      return objc_getAssociatedObject(object, key) as? T
   }

   public static func setAssign<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_ASSIGN)
   }

   public static func setRetainNonAtomic<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
   }

   public static func setCopyNonAtomic<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_COPY_NONATOMIC)
   }

   public static func setRetain<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_RETAIN)
   }

   public static func setCopy<T>(value: T?, to object: Any, forKey key: UnsafeRawPointer) {
      objc_setAssociatedObject(object, key, value, .OBJC_ASSOCIATION_COPY)
   }
}
