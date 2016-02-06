//
// NSDateFormatter.swift
// WLCore
//
// Created by Vlad Gorlov on 05.11.15.
// Copyright (c) 2015 WaveLabs. All rights reserved.
//

public extension NSDateFormatter {
	public static func localizedStringFromDate(date: NSDate, dateFormat: String) -> String {
		let f = NSDateFormatter()
		f.dateFormat = dateFormat
		return f.stringFromDate(date)
	}
}
