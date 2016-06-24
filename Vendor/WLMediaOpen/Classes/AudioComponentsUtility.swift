//
//  AudioComponentsUtility.swift
//  WLMedia
//
//  Created by User on 6/25/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import AVFoundation

public final class AudioComponentsUtility {

	public enum StateChange {
		case AudioComponentRegistered
		case AudioComponentInstanceInvalidated(AUAudioUnit, AudioUnit?)
	}

	private var observerOfComponentChange: NotificationObserver?
	private var observerOfComponentInvalidate: NotificationObserver?
	private lazy var log: Logger = Logger(sender: self, context: .Media)
	private lazy var notificationsQueue = NSOperationQueue.Concurrent.Utility()

	public var handlerStateChange: (StateChange -> Void)?
	public var completionHandlerQueue = DispatchQueue.Main

	public init() {
		setUpObservers()
		log.logInit()
	}

	deinit {
		tearDownObservers()
		log.logDeinit()
	}

	/// **Note** Always calls completion handler on main queue
	/// - parameter queue: Queue used to query components.
	/// - parameter completion: Result completion handler.
	public func updateEffectList(queue: dispatch_queue_t = DispatchQueue.Utility, completion: [AVAudioUnitComponent] -> Void) {
		// Locating components can be a little slow, especially the first time.
		// Do this work on a separate dispatch thread.
		dispatch_async(queue) { [weak self] in guard let s = self else { return }
			var anyEffectDescription = AudioComponentDescription()
			anyEffectDescription.componentType = kAudioUnitType_Effect
			anyEffectDescription.componentSubType = 0
			anyEffectDescription.componentManufacturer = 0
			anyEffectDescription.componentFlags = 0
			anyEffectDescription.componentFlagsMask = 0
			let effects = AVAudioUnitComponentManager.sharedAudioUnitComponentManager()
				.componentsMatchingDescription(anyEffectDescription)

			dispatch_async(s.completionHandlerQueue) {
				completion(effects)
			}
		}
	}

	// MARK: - Private

	private func setUpObservers() {
		observerOfComponentChange = NotificationObserver(notificationName:
			kAudioComponentRegistrationsChangedNotification as String, queue: notificationsQueue) { [weak self] _ in
				guard let s1 = self else {
					return
				}
				dispatch_async(s1.completionHandlerQueue) { [weak s1] in
					guard let s2 = s1 else {
						return
					}
					s2.handlerStateChange?(.AudioComponentRegistered)
				}
		}

		observerOfComponentChange = NotificationObserver(notificationName:
			kAudioComponentInstanceInvalidationNotification as String, queue: notificationsQueue) {[weak self] notification in
				guard let s1 = self else {
					return
				}
				guard let crashedAU = notification.object as? AUAudioUnit else {
					fatalError()
				}
				var audioUnit: AudioUnit?
				if let value = notification.userInfo?["audioUnit"] as? NSValue {
					let pointer = unsafeBitCast(value.pointerValue, UnsafeMutablePointer<AudioUnit>.self)
					audioUnit = pointer.memory
				}
				dispatch_async(s1.completionHandlerQueue) { [weak s1] in
					guard let s2 = s1 else {
						return
					}
					s2.handlerStateChange?(.AudioComponentInstanceInvalidated(crashedAU, audioUnit))
				}
		}
	}

	private func tearDownObservers() {
		observerOfComponentChange = nil
		observerOfComponentInvalidate = nil
	}
}
