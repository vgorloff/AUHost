//
//  NSNotification.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 01.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

//private class NSNotificationPayload<T> {
//	private var value: T
//	init(value aValue: T) {
//		value = aValue
//	}
//}
//private enum NSNotificationUserInfoKey: String {
//	case Payload = "payload"
//}
//
//public extension NSNotification {
//
//	public convenience init<T>(payload: T) {
//		let payloadObjectValue = NSNotificationPayload(value: payload)
//		self.init(name: "some-name", object: nil, userInfo: [NSNotificationUserInfoKey.Payload.rawValue : payloadObjectValue])
//	}
//
//	public func payload<T>() -> T? {
//		if let typeWarpper = userInfo?[NSNotificationUserInfoKey.Payload.rawValue] as? NSNotificationPayload<T> {
//			return typeWarpper.value
//		}
//		return nil
//	}
//}
