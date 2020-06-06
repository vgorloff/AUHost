//
//  Label.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class Label: NSTextField {

   public convenience init(title: String) {
      self.init()
      self.title = title
   }

   public convenience init(text: String) {
      self.init()
      title = text
   }

   public init() {
      super.init(frame: NSRect())
      isEditable = false
      drawsBackground = false
      isBezeled = false
      translatesAutoresizingMaskIntoConstraints = false
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   public var numberOfLines: Int {
      get {
         return maximumNumberOfLines
      } set {
         maximumNumberOfLines = newValue
      }
   }
}
#endif
