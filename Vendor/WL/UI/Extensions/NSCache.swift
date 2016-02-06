//
//  NSCache.swift
//  WLUI
//
//  Created by Vlad Gorlov on 06.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#if os(iOS)
import UIKit
#endif

public extension NSCache {

	#if os(iOS)
	public func setImage(value: UIImage, forKey: AnyObject) {
		setObject(value, forKey: forKey)
	}

	public func imageForKey(forKey: AnyObject) -> UIImage? {
		return objectForKey(forKey) as? UIImage
	}
	#endif
}
