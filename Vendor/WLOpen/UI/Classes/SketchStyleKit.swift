//
//  SketchStyleKit.swift
//  WLUI
//
//  Created by Vlad Gorlov on 30.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

#if os(iOS)
	import UIKit.UIFont
	public typealias FontType = UIFont
#elseif os(OSX)
	import AppKit.NSFont
	public typealias FontType = NSFont
#endif

public final class SketchStyleKit {

	public enum Error: ErrorType {
		case UnexpectedDataType
	}

	private typealias PlistEntry = [String: AnyObject]
	private struct Metadata {
		var documentScale: Int
	}

	// MARK: -

	public final class Fill {
		public var color: ColorType
		private init(plist: PlistEntry) {
			let colorValue: String = trycrash(try plist.valueForRequiredKey("color"))
			let colorInstance = colorValue.hasPrefix("#") ? ColorType(hexString: colorValue) :
				ColorType(rgba: colorValue, rgbCompomentsIn256Range: true)
			guard let c = colorInstance else {
				fatalError()
			}
			color = c
		}
	}

	public final class TextStyle {
		public var color: ColorType
		private var fontName: String
		private var fontFize: Int
		private lazy var _font: FontType? = self.makeFont()
		public var font: FontType? {
			return _font
		}
		private init(plist: PlistEntry) {
			let colorValue: String = trycrash(try plist.valueForRequiredKey("NSColor"))
			fontName = trycrash(try plist.valueForRequiredKey("fontName"))
			fontFize = trycrash(try plist.valueForRequiredKey("fontFize"))
			guard let c = ColorType(rgba: colorValue) else {
				fatalError()
			}
			color = c
		}
		private func makeFont() -> FontType? {
			return FontType(name: fontName, size: CGFloat(fontFize) / CGFloat(SketchStyleKit.metadata.documentScale))
		}
	}

	public struct LayerStyle {
		public var fills = [Fill]()
		public var borders = [Fill]()
		private init(plist: PlistEntry) {
			if let fillsValue: [PlistEntry] = plist.valueForKey("fills") {
				for fillValue in fillsValue {
					let fill = Fill(plist: fillValue)
					fills.append(fill)
				}
			}
			if let bordersValue: [PlistEntry] = plist.valueForKey("borders") {
				for borderValue in bordersValue {
					let border = Fill(plist: borderValue)
					borders.append(border)
				}
			}
		}
	}

	public struct LayerTextStyle {
		public var fills = [Fill]()
		public var borders = [Fill]()
		public var textStyle: TextStyle?
		private init(plist: PlistEntry) {
			if let fillsValue: [PlistEntry] = plist.valueForKey("fills") {
				for fillValue in fillsValue {
					let fill = Fill(plist: fillValue)
					fills.append(fill)
				}
			}
			if let bordersValue: [PlistEntry] = plist.valueForKey("borders") {
				for borderValue in bordersValue {
					let border = Fill(plist: borderValue)
					borders.append(border)
				}
			}
			if let textStyleValue: PlistEntry = plist.valueForKey("textStyle") {
				textStyle = TextStyle(plist: textStyleValue)
			}
		}
	}

	public final class LayerStyles {
		private var plist: [PlistEntry]
		private var cachedStyles = [String: LayerStyle]()
		private init(plist aPlist: [PlistEntry]) {
			plist = aPlist
		}
		public subscript(styleID: String) -> LayerStyle? {
			if cachedStyles.hasKey(styleID) {
				return cachedStyles.valueForKey(styleID)
			} else {
				let matches = trycrash(try plist.filter { element in
					let styleIDValue: String = try element.valueForRequiredKey("styleID")
					return styleIDValue == styleID
					})
				guard let match = matches.first else {
					return nil
				}
				let styleValue: PlistEntry = trycrash(try match.valueForRequiredKey("style"))
				let layerStyle = LayerStyle(plist: styleValue)
				cachedStyles[styleID] = layerStyle
				return layerStyle
			}
		}
	}

	public final class LayerTextStyles {
		private var plist: [PlistEntry]
		private var cachedStyles = [String: LayerTextStyle]()
		private init(plist aPlist: [PlistEntry]) {
			plist = aPlist
		}
		public subscript(styleID: String) -> LayerTextStyle? {
			if cachedStyles.hasKey(styleID) {
				return cachedStyles.valueForKey(styleID)
			} else {
				let matches = trycrash(try plist.filter { element in
					let styleIDValue: String = try element.valueForRequiredKey("styleID")
					return styleIDValue == styleID
					})
				guard let match = matches.first else {
					return nil
				}
				let styleValue: PlistEntry = trycrash(try match.valueForRequiredKey("style"))
				let layerStyle = LayerTextStyle(plist: styleValue)
				cachedStyles[styleID] = layerStyle
				return layerStyle
			}
		}
	}

	// MARK: -

	public var layerStyles: LayerStyles {
		return _layerStyles
	}
	public var layerTextStyles: LayerTextStyles {
		return _layerTextStyles
	}

	// MARK: -
	private static var metadata: Metadata!
	private var _layerStyles: LayerStyles!
	private var _layerTextStyles: LayerTextStyles!

	public init(plistURL: NSURL) throws {
		let dictionary = try NSDictionary.readPlistFromURL(plistURL)
		guard let plist = dictionary as? [String: AnyObject] else {
			throw Error.UnexpectedDataType
		}
		let metadataValue: PlistEntry = try plist.valueForRequiredKey("metadata")
		let documentScale: Int = try metadataValue.valueForRequiredKey("documentScale")
		SketchStyleKit.metadata = Metadata(documentScale: documentScale)
		let layerStylesValue: [PlistEntry] = try plist.valueForRequiredKey("layerStyles")
		let layerTextStylesValue: [PlistEntry] = try plist.valueForRequiredKey("layerTextStyles")
		_layerStyles = LayerStyles(plist: layerStylesValue)
		_layerTextStyles = LayerTextStyles(plist: layerTextStylesValue)
	}
}
