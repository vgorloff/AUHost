//
//  WebViewController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 24.11.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)

import Foundation
import mcUI
import UIKit
import WebKit

public class WebViewController: ViewController {

   private lazy var webView = WKWebView(frame: .zero).autolayoutView()
   private let html: String

   public init(html: String) {
      self.html = html
      super.init()
   }

   required init?(coder: NSCoder) {
      fatalError()
   }

   override public func setupUI() {
      view.addSubview(webView)
      anchor.pin.toMargins(webView).activate()
      webView.loadHTMLString(html, baseURL: nil)
   }
}

#endif
