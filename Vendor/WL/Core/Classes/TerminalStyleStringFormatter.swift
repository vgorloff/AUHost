//
//  TerminalStyleStringFormatter.swift
//  WLCore
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

// swiftlint:disable type_name
/// - SeeAlso: [ bash:tip_colors_and_formatting - FLOZz' MISC ]( http://misc.flogisoft.com/bash/tip_colors_and_formatting )
public struct TerminalStyleStringFormatter {
	private static let escape = "\u{001B}["
	private enum ColorCode: Int {
		case Black = 0, Red, Green, Yellow, Blue, Magenta, Cyan, LightGray
		var fgColorNormal: Int { return self.rawValue + 30 }
		var fgColorLight: Int { return self.rawValue + 90 }
		static var fgColorDefault: Int { return 39 }
		var bgColorNormal: Int { return self.rawValue + 40 }
		var bgColorLight: Int { return self.rawValue + 100 }
		static var bgColorDefault: Int { return 49 }
	}

	public struct bg {
		public struct light { // swiftlint:disable:this nesting
			public static func darkGray(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Black) }
			public static func red(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Red) }
			public static func green(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Green) }
			public static func yellow(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Yellow) }
			public static func blue(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Blue) }
			public static func magenta(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Magenta) }
			public static func cyan(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Cyan) }
			public static func white(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.LightGray) }
			public static func k(string: String) -> String { return darkGray(string) }
			public static func r(string: String) -> String { return red(string) }
			public static func g(string: String) -> String { return green(string) }
			public static func y(string: String) -> String { return yellow(string) }
			public static func b(string: String) -> String { return blue(string) }
			public static func m(string: String) -> String { return magenta(string) }
			public static func c(string: String) -> String { return cyan(string) }
			public static func w(string: String) -> String { return white(string) }
			private static func formatColor(string string: String, colorCode: ColorCode) -> String {
				return "\(escape)\(colorCode.bgColorLight)m\(string)\(escape)\(ColorCode.bgColorDefault)m"
			}
		}
		public static func black(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Black) }
		public static func red(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Red) }
		public static func green(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Green) }
		public static func yellow(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Yellow) }
		public static func blue(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Blue) }
		public static func magenta(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Magenta) }
		public static func cyan(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Cyan) }
		public static func lightGray(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.LightGray) }
		public static func k(string: String) -> String { return black(string) }
		public static func r(string: String) -> String { return red(string) }
		public static func g(string: String) -> String { return green(string) }
		public static func y(string: String) -> String { return yellow(string) }
		public static func b(string: String) -> String { return blue(string) }
		public static func m(string: String) -> String { return magenta(string) }
		public static func c(string: String) -> String { return cyan(string) }
		public static func w(string: String) -> String { return lightGray(string) }
		private static func formatColor(string string: String, colorCode: ColorCode) -> String {
			return "\(escape)\(colorCode.bgColorNormal)m\(string)\(escape)\(ColorCode.bgColorDefault)m"
		}
	}

	// Styles
	public struct style {
		public static func b(string: String) -> String { return formatStyle(string: string, formatCode: 1) }
		public static func u(string: String) -> String { return formatStyle(string: string, formatCode: 4) }
		private static func formatStyle(string string: String, formatCode: Int, resetCode: Int = 0) -> String {
			return "\(escape)\(formatCode)m\(string)\(escape)\(resetCode)m"
		}
	}
	public static func bold(string: String) -> String { return style.b(string) }
	public static func underline(string: String) -> String { return style.u(string) }

	// Colors
	public static func black(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Black) }
	public static func red(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Red) }
	public static func green(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Green) }
	public static func yellow(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Yellow) }
	public static func blue(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Blue) }
	public static func magenta(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Magenta) }
	public static func cyan(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Cyan) }
	public static func lightGray(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.LightGray) }
	public static func k(string: String) -> String { return black(string) }
	public static func r(string: String) -> String { return red(string) }
	public static func g(string: String) -> String { return green(string) }
	public static func y(string: String) -> String { return yellow(string) }
	public static func b(string: String) -> String { return blue(string) }
	public static func m(string: String) -> String { return magenta(string) }
	public static func c(string: String) -> String { return cyan(string) }
	public static func w(string: String) -> String { return lightGray(string) }
	private static func formatColor(string string: String, colorCode: ColorCode) -> String {
		return "\(escape)\(colorCode.fgColorNormal)m\(string)\(escape)\(ColorCode.fgColorDefault)m"
	}

	public struct light {
		public static func darkGray(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Black) }
		public static func red(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Red) }
		public static func green(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Green) }
		public static func yellow(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Yellow) }
		public static func blue(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Blue) }
		public static func magenta(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Magenta) }
		public static func cyan(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.Cyan) }
		public static func white(string: String) -> String { return formatColor(string: string, colorCode: ColorCode.LightGray) }
		public static func k(string: String) -> String { return darkGray(string) }
		public static func r(string: String) -> String { return red(string) }
		public static func g(string: String) -> String { return green(string) }
		public static func y(string: String) -> String { return yellow(string) }
		public static func b(string: String) -> String { return blue(string) }
		public static func m(string: String) -> String { return magenta(string) }
		public static func c(string: String) -> String { return cyan(string) }
		public static func w(string: String) -> String { return white(string) }
		private static func formatColor(string string: String, colorCode: ColorCode) -> String {
			return "\(escape)\(colorCode.fgColorLight)m\(string)\(escape)\(ColorCode.fgColorDefault)m"
		}
	}
}
// swiftlint:enable type_name
