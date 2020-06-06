//
//  ProgressIndicator.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 08.06.18.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public class ProgressIndicator: NSProgressIndicator {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      translatesAutoresizingMaskIntoConstraints = false
   }

   required init?(coder decoder: NSCoder) {
      fatalError()
   }
}
#endif
