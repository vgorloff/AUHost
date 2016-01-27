//
//  MediaItemView.swift
//  AudioUnitExtensionDemo
//
//  Created by Vlad Gorlov on 22.06.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Cocoa
import AVFoundation
import WLShared
import Accelerate

public struct WaveformCacheUtility {

	private static let cache: NSCache = CacheCentre.cacheForIdentifier("WaveformCacheUtility")

	private static let defaultBufferFrameCapacity: UInt64 = 1024 * 8
	init() {
	}

	func cachedWaveformForResolution(url: NSURL, resolution: UInt64) -> [MinMax<Float>]? {
		let existedWaveform: [MinMax<Float>]? = WaveformCacheUtility.cache.objectValueForKey(WaveformCacheUtility.cacheID(url, resolution: resolution))
		if let wf = existedWaveform {
			return wf
		}
		return nil
	}

	func buildWaveformForResolution(fileURL url: NSURL, resolution: UInt64, callback: ResultType<[MinMax<Float>]> -> Void) {
		assert(resolution > 0)
		Dispatch.Async.UserInitiated {
			do {
				defer {
					url.stopAccessingSecurityScopedResource() // Seems working fine without this line
				}
				url.startAccessingSecurityScopedResource() // Seems working fine without this line
				let audioFile = try AVAudioFile(forReading: url, commonFormat: .PCMFormatFloat32, interleaved: false)
				let optimalBufferSettings = Math.optimalBufferSizeForResolution(resolution, dataSize: UInt64(audioFile.length),
					maxBufferSize: WaveformCacheUtility.defaultBufferFrameCapacity)
				let buffer = AVAudioPCMBuffer(PCMFormat: audioFile.processingFormat,
					frameCapacity: AVAudioFrameCount(optimalBufferSettings.optimalBufferSize))

				var waveformCache = Array<MinMax<Float>>()
				var groupingBuffer = Array<MinMax<Float>>()
				while audioFile.framePosition < audioFile.length {
					try audioFile.readIntoBuffer(buffer)
					let data = WaveformCacheUtility.processBuffer(buffer)
					groupingBuffer.append(data)
					if groupingBuffer.count >= Int(optimalBufferSettings.numberOfBuffers) {
						assert(groupingBuffer.count > 0)
						let waveformValue = groupingBuffer.suffixFrom(1).reduce(groupingBuffer[0]) { prev, el in
							return MinMax(min: prev.min + el.min, max: prev.max + el.max)
						}
						let avarageValue = MinMax(min: waveformValue.min / Float(groupingBuffer.count),
							max: waveformValue.max / Float(groupingBuffer.count))
						waveformCache.append(avarageValue)
						groupingBuffer.removeAll(keepCapacity: true)
					}
				}
				assert(UInt64(waveformCache.count) == resolution)
				WaveformCacheUtility.cache.setObjectValue(waveformCache, forKey: WaveformCacheUtility.cacheID(url, resolution: resolution))
				callback(.Success(waveformCache))
			} catch {
				callback(.Failure(error))
			}
		}
	}

	private static func cacheID(url: NSURL, resolution: UInt64) -> String {
		return "WaveForm:\(resolution):\(url.absoluteString)"
	}

	private static func processBuffer(buffer: AVAudioPCMBuffer) -> MinMax<Float> {

		//		let numElementsToProcess = vDSP_Length(buffer.frameLength * buffer.format.channelCount)
		//		var maximumMagnitudeValue: Float = 0
		//		var minimumMagnitudeValue: Float = 0
		//		vDSP_maxv(buffer.floatChannelData.memory, 1, &maximumMagnitudeValue, numElementsToProcess)
		//		vDSP_minv(buffer.floatChannelData.memory, 1, &minimumMagnitudeValue, numElementsToProcess)
		//		Swift.print(minimumMagnitudeValue, maximumMagnitudeValue, "\n")

		//Swift.print(buffer.frameLength)
		var channelValues = [MinMax<Float>]()
		let mbl = UnsafeMutableAudioBufferListPointer(buffer.mutableAudioBufferList)
		for index in 0 ..< mbl.count {
			let bl = mbl[index]
			let samplesBI = UnsafePointer<Float>(bl.mData)
			let numElementsToProcess = vDSP_Length(buffer.frameLength)
			var maximumMagnitudeValue: Float = 0
			var minimumMagnitudeValue: Float = 0
			vDSP_maxv(samplesBI, 1, &maximumMagnitudeValue, numElementsToProcess)
			vDSP_minv(samplesBI, 1, &minimumMagnitudeValue, numElementsToProcess)
			//Swift.print(minimumMagnitudeValue, maximumMagnitudeValue)
			channelValues.append(MinMax(min: minimumMagnitudeValue, max: maximumMagnitudeValue))
		}
		assert(channelValues.count > 0)
		let result = channelValues.suffixFrom(1).reduce(channelValues[0]) { prev, el in
			return MinMax(min: prev.min + el.min, max: prev.max + el.max)
		}
		return MinMax(min: result.min / Float(channelValues.count), max: result.max / Float(channelValues.count))
	}
}

public final class MediaItemView: NSView {
	private var isHighlighted = false {
		didSet {
			needsDisplay = true
		}
	}
	private let textDragAndDropMessage: NSString = "Drop media file here..."
	private var textDragAndDropColor = AlternativeValue<NSColor>(NSColor.grayColor(), altValue: NSColor.whiteColor())
	private let textDragAndDropFont = NSFont.labelFontOfSize(17)
	private let waveformColor = NSColor(hexString: "#51A2F3") ?? NSColor.redColor()
	private let pbUtil = MediaObjectPasteboardUtility()
	private lazy var wfCache = WaveformCacheUtility()
	private lazy var wfDrawingProvider = WaveformDrawingDataProvider(dataType: .CGPoint)
	var mediaFileURL: NSURL? {
		didSet {
			rebuildWaveform()
		}
	}
	public override var frame: NSRect {
		didSet {
			rebuildWaveform()
		}
	}

	private func rebuildWaveform() {
		guard let mf = mediaFileURL else {
			return
		}
		wfCache.buildWaveformForResolution(fileURL: mf, resolution: UInt64(bounds.width * getScaleFactor())) { [weak self] result in
			switch result {
			case .Failure(let e):
				Swift.print(e)
			case .Success(_):
				Dispatch.Async.Main { [weak self] in
					self?.needsDisplay = true
				}
			}
		}
	}

	private func cachedWaveform() -> [MinMax<Float>]? {
		guard let mf = mediaFileURL else {
			return nil
		}
		return wfCache.cachedWaveformForResolution(mf, resolution: UInt64(bounds.width * getScaleFactor()))
	}

	public var onCompleteDragWithObjects: (MediaObjectPasteboardUtility.PasteboardObjects -> Void)?

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

	public override func drawRect(dirtyRect: NSRect) {
		NSColor.whiteColor().setFill()
		NSRectFill(dirtyRect)
		(isHighlighted ? NSColor.keyboardFocusIndicatorColor() : NSColor.gridColor()).setStroke()
		let borderWidth = isHighlighted ? 2.CGFloatValue : 1.CGFloatValue
		NSBezierPath.setDefaultLineWidth(borderWidth)
		NSBezierPath.strokeRect(bounds.insetBy(dx: 0.5 * borderWidth, dy: 0.5 * borderWidth))

		textDragAndDropColor.useAltValue = cachedWaveform() != nil
		drawWaveform()
		drawTextMessage()
	}

	// MARK: - NSDraggingDestination

	public override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
		let result = pbUtil.objectsFromPasteboard(sender.draggingPasteboard())
		switch result {
		case .None:
			isHighlighted = false
			return NSDragOperation.None
		case .FilePaths, .MediaObjects:
			isHighlighted = true
			return NSDragOperation.Every
		}
	}

	public override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
		return NSDragOperation.Every
	}

	public override func draggingExited(sender: NSDraggingInfo?) {
		isHighlighted = false
	}

	public override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
		return true
	}

	public override func performDragOperation(sender: NSDraggingInfo) -> Bool {
		let result = pbUtil.objectsFromPasteboard(sender.draggingPasteboard())
		switch result {
		case .None:
			isHighlighted = false
			return false
		case .MediaObjects(let dict):
			Dispatch.Async.Main { [weak self] in
				self?.onCompleteDragWithObjects?(.MediaObjects(dict))
			}
			return true
		case .FilePaths(let acceptedFilePaths):
			Dispatch.Async.Main { [weak self] in
				self?.onCompleteDragWithObjects?(.FilePaths(acceptedFilePaths))
			}
			return true
		}
	}

	public override func concludeDragOperation(sender: NSDraggingInfo?) {
		isHighlighted = false
	}

	// MARK: - Private

	private func getScaleFactor() -> CGFloat {
		let backingSize = convertSizeToBacking(bounds.size)
		return backingSize.width / bounds.size.width
	}

	private func drawWaveform() {

		// !inLiveResize,
		guard !inLiveResize, let context = NSGraphicsContext.currentContext()?.CGContext, let waveform = cachedWaveform() else {
			return // FIXME: Implement interpolation for live resize and while waiting for waveform cashe arrival. By Vlad Gorlov, Jan 27, 2016.
		}
		let scaleFactor = getScaleFactor()
		let lineWidth = 1 / scaleFactor

		assert(Int(bounds.width * scaleFactor) == waveform.count)
		wfDrawingProvider.reset(xOffset: 0.5 * lineWidth, yOffset: 0.5 * lineWidth, width: bounds.width - lineWidth,
			height: bounds.height - lineWidth)
		for index in 0..<waveform.count {
			let waveformValue = waveform[index]
			wfDrawingProvider.addVerticalLineAtXPosition(index.CGFloatValue / scaleFactor, valueMin: waveformValue.min.CGFloatValue,
				valueMax: waveformValue.max.CGFloatValue)
		}
		CGContextSetShouldAntialias(context, false);
//		CGContextSetFillColorWithColor(context, NSColor.whiteColor().CGColor)
		CGContextTranslateCTM(context, 0.5 / scaleFactor, 0.5 / scaleFactor); // Center the origin at center of a pixel

		CGContextSaveGState(context)
//		CGContextFillRect(context, bounds)
		CGContextSetStrokeColorWithColor(context, waveformColor.CGColor)
		CGContextSetLineWidth(context, lineWidth);
		CGContextStrokeLineSegments(context, wfDrawingProvider.points, wfDrawingProvider.numberOfPoints)
		CGContextRestoreGState(context)
	}

	private func drawTextMessage() {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.alignment = NSTextAlignment.Center
		let attributes = [NSParagraphStyleAttributeName: paragraphStyle,
			NSForegroundColorAttributeName: textDragAndDropColor.currentValue,
			NSFontAttributeName: textDragAndDropFont]
		let textSize = textDragAndDropMessage.sizeWithAttributes(attributes)
		let offsetX = bounds.height - textSize.height
		textDragAndDropMessage.drawInRect(bounds.insetBy(dx: 8, dy: offsetX * 0.5), withAttributes: attributes)
	}

}




public final class WaveformDrawingDataProvider {

	public enum ModelDataType: Int {
		case CGPoint
		case IntVertice
		case FloatVertice
	}

	private var _points = [CGPoint]()
	private var _verticesI = [Int32]()
	private var _verticesF = [Float]()
	private var dataType: ModelDataType
	private var width: CGFloat = 0
	private var height: CGFloat = 0
	private var xOffset: CGFloat = 0
	private var yOffset: CGFloat = 0

	public init(dataType aDataType: ModelDataType) {
		dataType = aDataType
	}

	public func addHorizontalLine(yPosition: CGFloat) {
		switch dataType {
		case .CGPoint:
			fatalError("Not up to date")
			_points.append(CGPoint(x: xOffset, y: yPosition))
			_points.append(CGPoint(x: xOffset + width, y: yPosition))
		case .IntVertice:
			fatalError("Not up to date")
			_verticesI.appendContentsOf([Int32(xOffset), Int32(yPosition),
				Int32(xOffset + width), Int32(yPosition)])
		case .FloatVertice:
			fatalError("Not up to date")
			_verticesF.appendContentsOf([Float(xOffset), Float(yPosition),
				Float(xOffset + width), Float(yPosition)])
		}
	}

	public func addVerticalLineAtXPosition(xPosition: CGFloat, valueMin: CGFloat, valueMax: CGFloat) {
		switch dataType {
		case .CGPoint:
			let middleY = 0.5 * height
			let halfAmplitude = middleY
			_points.append(CGPoint(x: xPosition, y: yOffset + middleY - halfAmplitude * valueMin))
			_points.append(CGPoint(x: xPosition, y: yOffset + middleY - halfAmplitude * valueMax))
		case .IntVertice:
			fatalError("Not up to date")
			_verticesI.appendContentsOf([Int32(xPosition), Int32(yOffset),
				Int32(xPosition), Int32(yOffset + height)])
		case .FloatVertice:
			fatalError("Not up to date")
			_verticesF.appendContentsOf([Float(xPosition), Float(yOffset),
				Float(xPosition), Float(yOffset + height)])
		}
	}

	public var points: UnsafePointer<CGPoint> {
		let result = _points.withUnsafeBufferPointer({pointerVal -> UnsafePointer<CGPoint> in
			return pointerVal.baseAddress}
		)
		return result
	}

	public var numberOfPoints: Int {
		return _points.count
	}

	public var verticesI: UnsafePointer<Int32> {
		let result = _verticesI.withUnsafeBufferPointer({pointerVal -> UnsafePointer<Int32> in
			return pointerVal.baseAddress}
		)
		return result
	}

	public var numberOfIntVertices: Int {
		return _verticesI.count
	}

	public var verticesF: [Float] {
		return _verticesF
	}

	public func reset(xOffset anXOffset: CGFloat, yOffset anYOffset: CGFloat, width aWidth: CGFloat, height aHeight: CGFloat) {
		xOffset = anXOffset
		yOffset = anYOffset
		width = aWidth
		height = aHeight
		switch dataType {
		case .CGPoint:
			_points.removeAll(keepCapacity: true)
		case .IntVertice:
			_verticesI.removeAll(keepCapacity: true)
		case .FloatVertice:
			_verticesF.removeAll(keepCapacity: true)
		}
	}
	
}

