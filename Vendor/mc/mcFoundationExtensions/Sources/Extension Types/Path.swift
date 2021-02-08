//
//  Path.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation

public class Path {

   let path: String

   init(path: String) {
      self.path = path
   }

   public var `extension`: String {
      return (path as NSString).pathExtension
   }

   public func appendingComponent(_ component: String) -> String {
      return (path as NSString).appendingPathComponent(component)
   }

   public func appendingComponents(_ values: [String]) -> String {
      return values.reduce(path) { $0.asPath.appendingComponent($1) }
   }

   public func appendingComponents(_ values: String...) -> String {
      return values.reduce(path) { $0.asPath.appendingComponent($1) }
   }

   public func deletingLastComponent() -> String {
      return (path as NSString).deletingLastPathComponent
   }

   public func deletingLastPathComponents(_ numberOfComponents: Int) -> String {
      var result = path
      for _ in 0 ..< numberOfComponents {
         result = result.asPath.deletingLastComponent()
      }
      return result
   }
}
