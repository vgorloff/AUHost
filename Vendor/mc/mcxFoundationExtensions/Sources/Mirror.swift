//
//  Mirror.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

extension Mirror {

   public init(_ subject: Any, children: [String: Any], ancestorRepresentation: Mirror.AncestorRepresentation = .generated) {
      let c: [Mirror.Child] = children.map { Mirror.Child(label: $0.key, value: $0.value) }
      self.init(subject, children: c, ancestorRepresentation: ancestorRepresentation)
   }
}
