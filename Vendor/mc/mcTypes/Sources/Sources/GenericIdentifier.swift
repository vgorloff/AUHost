//
//  GenericIdentifier.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

public struct GenericIdentifier<Owner, IdentifierType>: RawRepresentable {
   public let rawValue: IdentifierType

   public init(rawValue: IdentifierType) {
      self.rawValue = rawValue
   }
}

extension GenericIdentifier: Equatable where IdentifierType: Equatable {
   public static func == (lhs: GenericIdentifier, rhs: GenericIdentifier) -> Bool {
      return lhs.rawValue == rhs.rawValue
   }
}

extension GenericIdentifier: Hashable where IdentifierType: Hashable {
   public var hashValue: Int { return rawValue.hashValue }
}

extension GenericIdentifier: ExpressibleByIntegerLiteral where IdentifierType == Int {
   public typealias IntegerLiteralType = Int

   public init(integerLiteral value: Int) {
      rawValue = value
   }
}

extension GenericIdentifier: Decodable where IdentifierType: Decodable {
   public init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      rawValue = try container.decode(IdentifierType.self)
   }
}

extension GenericIdentifier: Encodable where IdentifierType: Encodable {
   public func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      try container.encode(rawValue)
   }
}

public protocol Identifiable {
   associatedtype IdentifierRawType: Codable = Int

   typealias Identifier = GenericIdentifier<Self, IdentifierRawType>
}
