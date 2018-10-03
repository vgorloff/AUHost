//
//  QuickLookProxy.swift
//  Foundation
//
//  Created by Vlad Gorlov on 20.08.18.
//  Copyright © 2018 WaveLabs. All rights reserved.
//

import Foundation

public typealias QLP = QuickLookProxy

public class QuickLookProxy: NSObject {

   public typealias Transformer = (Any) -> QuickLookProxyType?

   private static var transformers: [(Any.Type, Transformer)] = []

   public static func register(for type: Any.Type, transformer: @escaping Transformer) {
      transformers.append((type, transformer))
   }

   public private(set) var object: AnyObject?

   public init(_ value: Any) {
      super.init()
      let transformers = type(of: self).transformers.filter { $0.0 == type(of: value) }.map { $0.1 }
      for transformer in transformers {
         if let value = transformer(value), let object = QuickLookFactory.object(from: value) {
            self.object = object
            break
         }
      }
   }

   @objc public func debugQuickLookObject() -> AnyObject? {
      return object
   }

   public override var description: String {
      return object?.description ?? "nil"
   }
}

extension QuickLookProxy {
}
