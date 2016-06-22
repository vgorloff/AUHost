//
//  NotificationObserver.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 01.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public class NotificationObserver {

	public typealias HandleNotificationBlock = ((NSNotification) -> Void)
	private var notificationObserver: NSObjectProtocol!
	private var notificationCallbackBlock: HandleNotificationBlock?

	public init(notificationName: String,
		object: AnyObject? = nil,
		queue: NSOperationQueue = NSOperationQueue.mainQueue(),
		usingBlock: HandleNotificationBlock? = nil) {
			notificationCallbackBlock = usingBlock
			notificationObserver = NSNotificationCenter.defaultCenter().addObserverForName(notificationName,
				object: object, queue: queue) { [weak self] n in
					self?.handleNotification(n)
			}
	}

	deinit {
		notificationCallbackBlock = nil
		NSNotificationCenter.defaultCenter().removeObserver(notificationObserver)
	}

	/// Calls block which was passed as *usingBlock* parameter.
	/// Child classes may override to change default behaviour.
	/// - parameter notification: Notification to handle.
	public func handleNotification(notification: NSNotification) {
		if let callbackBlock = notificationCallbackBlock {
			callbackBlock(notification)
		}
	}

}
