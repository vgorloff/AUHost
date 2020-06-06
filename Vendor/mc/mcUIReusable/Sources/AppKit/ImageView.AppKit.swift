//
//  ImageView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 17.09.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public class ImageView: NSImageView {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      translatesAutoresizingMaskIntoConstraints = false
   }

   required init?(coder: NSCoder) {
      fatalError()
   }
}
#endif
