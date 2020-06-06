//
//  UIWebView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

@available(tvOS, unavailable)
extension UIWebView {

   public func clearContents() {
      if let url = URL(string: "about:blank") {
         loadRequest(URLRequest(url: url))
      } else {
         assert(false)
      }
   }
}
#endif
