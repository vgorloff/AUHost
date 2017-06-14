//
//  MediaItemView.swift
//  AUHost
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import AVFoundation
import Accelerate

public final class MediaItemView: NSView {
   private var isHighlighted = false {
      didSet {
         needsDisplay = true
      }
   }
   private let textDragAndDropMessage: NSString = "Drop media file here..."
   private var textDragAndDropColor = AlternativeValue<NSColor>(NSColor.gray, altValue: NSColor.white)
   private let textDragAndDropFont = NSFont.labelFont(ofSize: 17)
   private let waveformColor = NSColor(hexString: "#51A2F3") ?? NSColor.red
   private let pbUtil = MediaObjectPasteboardUtility()
   private lazy var wfCache = WaveformCacheUtility()
   private lazy var wfDrawingProvider = WaveformDrawingDataProvider()
   var mediaFileURL: URL? {
      didSet {
         rebuildWaveform()
      }
   }
   public override var frame: NSRect {
      didSet {
         rebuildWaveform()
      }
   }

   public var onCompleteDragWithObjects: ((MediaObjectPasteboardUtility.PasteboardObjects) -> Void)?

   // MARK: - Public

   required public init?(coder: NSCoder) {
      super.init(coder: coder)
      registerForDraggedTypes(pbUtil.draggedTypes)
   }

   public override init(frame frameRect: NSRect) {
      super.init(frame: frameRect)
      registerForDraggedTypes(pbUtil.draggedTypes)
   }

   deinit {
      unregisterDraggedTypes()
   }

   public override func draw(_ dirtyRect: NSRect) {
      NSColor.white.setFill()
      dirtyRect.fill()
      (isHighlighted ? NSColor.keyboardFocusIndicatorColor : NSColor.gridColor).setStroke()
      let borderWidth = isHighlighted ? 2.CGFloatValue : 1.CGFloatValue
      NSBezierPath.defaultLineWidth = borderWidth
      NSBezierPath.stroke(bounds.insetBy(dx: 0.5 * borderWidth, dy: 0.5 * borderWidth))

      textDragAndDropColor.useAltValue = cachedWaveform() != nil
      drawWaveform()
      drawTextMessage()
   }

   // MARK: - NSDraggingDestination

   public override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
      let result = pbUtil.objectsFromPasteboard(pasteboard: sender.draggingPasteboard())
      switch result {
      case .none:
         isHighlighted = false
         return []
      case .filePaths, .mediaObjects:
         isHighlighted = true
         return NSDragOperation.every
      }
   }

   public override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
      return NSDragOperation.every
   }

   public override func draggingExited(_ sender: NSDraggingInfo?) {
      isHighlighted = false
   }

   public override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
      return true
   }

   public override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
      let result = pbUtil.objectsFromPasteboard(pasteboard: sender.draggingPasteboard())
      switch result {
      case .none:
         isHighlighted = false
         return false
      case .mediaObjects(let dict):
         DispatchQueue.main.async { [weak self] in
            self?.onCompleteDragWithObjects?(.mediaObjects(dict))
         }
         return true
      case .filePaths(let acceptedFilePaths):
         DispatchQueue.main.async { [weak self] in
            self?.onCompleteDragWithObjects?(.filePaths(acceptedFilePaths))
         }
         return true
      }
   }

   public override func concludeDragOperation(_ sender: NSDraggingInfo?) {
      isHighlighted = false
   }

   // MARK: - Private

   private func getScaleFactor() -> CGFloat {
      let backingSize = convertToBacking(bounds.size)
      return backingSize.width / bounds.size.width
   }

   private func drawWaveform() {

      // !inLiveResize,
      guard !inLiveResize, let context = NSGraphicsContext.current?.cgContext, let waveform = cachedWaveform() else {
         return // FIXME: Implement interpolation for live resize and while waiting for waveform cashe arrival.
      }
      let scaleFactor = getScaleFactor()
      let lineWidth = 1 / scaleFactor

      assert(Int(bounds.width * scaleFactor) == waveform.count)
      wfDrawingProvider.reset(xOffset: 0.5 * lineWidth, yOffset: 0.5 * lineWidth, width: bounds.width - lineWidth,
                              height: bounds.height - lineWidth)
      for index in 0..<waveform.count {
         let waveformValue = waveform[index]
         wfDrawingProvider.addVerticalLineAtXPosition(xPosition: index.CGFloatValue / scaleFactor,
                                                      valueMin: waveformValue.min.CGFloatValue,
                                                      valueMax: waveformValue.max.CGFloatValue)
      }
      context.setShouldAntialias(false)
      //		CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor)
      context.translateBy(x: 0.5 / scaleFactor, y: 0.5 / scaleFactor); // Center the origin at center of a pixel

      context.saveGState()
      //		CGContextFillRect(context, bounds)
      context.setStrokeColor(waveformColor.cgColor)
      context.setLineWidth(lineWidth)
      context.strokeLineSegments(between: wfDrawingProvider.points)
      context.restoreGState()
   }

   private func drawTextMessage() {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = NSTextAlignment.center
      let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                        .foregroundColor: textDragAndDropColor.currentValue,
                        .font: textDragAndDropFont]
      let textSize = textDragAndDropMessage.size(withAttributes: attributes)
      let offsetX = bounds.height - textSize.height
      textDragAndDropMessage.draw(in: bounds.insetBy(dx: 8, dy: offsetX * 0.5), withAttributes: attributes)
   }

   private func rebuildWaveform() {
      guard let mf = mediaFileURL else {
         return
      }
      wfCache.buildWaveformForResolution(fileURL: mf as URL,
                                         resolution: UInt64(bounds.width * getScaleFactor())) { [weak self] result in
                                          switch result {
                                          case .failure(let e):
                                             Swift.print(e)
                                          case .success(_):
                                             DispatchQueue.main.async { [weak self] in
                                                self?.needsDisplay = true
                                             }
                                          }
      }
   }

   private func cachedWaveform() -> [MinMax<Float>]? {
      guard let mf = mediaFileURL else {
         return nil
      }
      return wfCache.cachedWaveformForResolution(url: mf, resolution: UInt64(bounds.width * getScaleFactor()))
   }

}
