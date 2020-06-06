//
//  TableView.AppKit.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.05.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class TableView: NSTableView {

   override public init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      intercellSpacing = CGSize(height: convertFromBacking(1))
      gridStyleMask = .solidHorizontalGridLineMask
      translatesAutoresizingMaskIntoConstraints = false
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   override open func drawGrid(inClipRect clipRect: NSRect) {
      // See: Draw grid lines in NSTableView only for populated rows - https://stackoverflow.com/q/5606796/1418981
      let lastRowRect = rect(ofRow: numberOfRows - 1)
      let newClipRect = CGRect(x: 0, y: 0, width: lastRowRect.size.width, height: lastRowRect.maxY)
      let finalClipRect = clipRect.intersection(newClipRect)
      super.drawGrid(inClipRect: finalClipRect)
   }
}
#endif
