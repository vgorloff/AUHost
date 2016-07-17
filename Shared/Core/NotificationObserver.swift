//
//  NotificationObserver.swift
//  WaveLabs
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
		queue: OperationQueue = OperationQueue.main,
		usingBlock: HandleNotificationBlock? = nil) {
			notificationCallbackBlock = usingBlock
			notificationObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: notificationName),
				object: object, queue: queue) { [weak self] n in
					self?.handleNotification(n)
			}
	}

	deinit {
		notificationCallbackBlock = nil
		NotificationCenter.default.removeObserver(notificationObserver)
	}

	/// Calls block which was passed as *usingBlock* parameter.
	/// Child classes may override to change default behaviour.
	/// - parameter notification: Notification to handle.
	public func handleNotification(_ notification: NSNotification) {
		if let callbackBlock = notificationCallbackBlock {
			callbackBlock(notification)
		}
	}

}
