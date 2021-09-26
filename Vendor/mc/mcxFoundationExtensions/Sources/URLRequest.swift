//
//  URLRequest.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 10.10.19.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

import Foundation

extension URLRequest {

   public func jsonBody() throws -> [AnyHashable: Any]? {
      if let body = httpBody {
         return try JSONSerialization.jsonObject(with: body, options: []) as? [AnyHashable: Any]
      } else {
         return nil
      }
   }
}
