//
//  GenericError.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10/02/2017.
//  Copyright © 2017 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct GenericError: LocalizedError, CustomStringConvertible {

   public enum Kind {
      case unableToInitialize(Any.Type)
   }

   public let description: String

   public init(_ description: String) {
      self.description = description
   }

   public init(kind: Kind) {
      description = kind.localizedDescription
   }

   public var errorDescription: String? {
      return description
   }
}

extension GenericError.Kind {

   // FIXME: Localize.
   var localizedDescription: String {
      switch self {
      case .unableToInitialize(let type):
         return "Unable to initialize \(String(describing: type))"
      }
   }
}
