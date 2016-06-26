//
//  WaveformDrawingDataProvider.swift
//  WLMedia
//
//  Created by Volodymyr Gorlov on 28.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import CoreGraphics

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
			return pointerVal.baseAddress
		})
		return result
	}

	public var numberOfPoints: Int {
		return _points.count
	}

	public var verticesI: UnsafePointer<Int32> {
		let result = _verticesI.withUnsafeBufferPointer({pointerVal -> UnsafePointer<Int32> in
			return pointerVal.baseAddress
		})
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
