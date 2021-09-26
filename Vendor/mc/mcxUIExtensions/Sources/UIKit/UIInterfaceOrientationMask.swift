//
//  UIInterfaceOrientationMask.swift
//  mcxUIExtensions
//
//  Created by Vlad Gorlov on 16.09.21.
//

#if canImport(UIKit)
import UIKit

extension UIInterfaceOrientationMask: CustomStringConvertible {

   public var description: String {
      var lines: [String] = []
      if contains(.all) {
         return "all"
      }
      if contains(.allButUpsideDown) {
         return "allButUpsideDown"
      }
      if contains(.landscape) {
         return "landscape"
      }
      if contains(.landscapeLeft) {
         lines.append("landscapeLeft")
      }
      if contains(.landscapeRight) {
         lines.append("landscapeRight")
      }
      if contains(.portrait) {
         lines.append("portrait")
      }
      if contains(.portraitUpsideDown) {
         lines.append("portraitUpsideDown")
      }

      return lines.joined(separator: "; ")
   }
}

#endif
