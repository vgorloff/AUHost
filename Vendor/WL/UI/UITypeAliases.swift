//
//  NSMutableAttributedString.swift
//  WLUI
//
//  Created by Vlad Gorlov on 21.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#if os(iOS)
	import UIKit
   public typealias FontType = UIFont
   public typealias ColorType = UIColor
   public typealias ViewType = UIView
   public typealias LayoutRelation = NSLayoutRelation
   public typealias LayoutFormatOptions = NSLayoutFormatOptions
#elseif os(OSX)
	import AppKit
   public typealias FontType = NSFont
   public typealias ColorType = NSColor
   public typealias ViewType = NSView
   public typealias LayoutRelation = NSLayoutConstraint.Relation
   public typealias LayoutFormatOptions = NSLayoutConstraint.FormatOptions
#endif
