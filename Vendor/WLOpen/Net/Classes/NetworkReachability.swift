//
//  NetworkReachability.swift
//  WLNet
//
//  Created by Vlad Gorlov on 04.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import SystemConfiguration

private func NetworkReachabilityCallBack(reachability: SCNetworkReachability,
	flags: SCNetworkReachabilityFlags, info: UnsafeMutablePointer<Void>) -> Void {
		let reachability = unsafeBitCast(info, NetworkReachability.self)
		reachability.reachabilityChangedWithFlags(flags)
}

public final class NetworkReachability {

	public enum Error: ErrorType {
		case UnableToCreateWithHostname(String)
		case UnableToCreateWithAddress(sockaddr_in)
		case UnableToSetCallback
		case UnableToSetDispatchQueue
	}

	public enum ConnectionType {
		case InternetConnection
		case LocalWiFi
	}

	public var reachabilityChanged: (SCNetworkReachabilityFlags -> Void)?

	// MARK: - Private

	private lazy var reachabilityDispatchQueue = DispatchQueue.serial("wl.networkReachability")
	private let callbackQueue: dispatch_queue_t
	private var monitoringRunning = false
	private var previousFlags: SCNetworkReachabilityFlags?
	private var reachability: SCNetworkReachability!
	public var reachabilityFlags: SCNetworkReachabilityFlags {
		return NetworkReachability.reachabilityFlags(reachability)
	}

	// MARK: -

	private init(reachability aReachability: SCNetworkReachability, callbackQueue aCallbackQueue: dispatch_queue_t) throws {
		reachability = aReachability
		callbackQueue = aCallbackQueue
	}

	// MARK: -

	public convenience init(hostname: String, callbackQueue: dispatch_queue_t = DispatchQueue.Main) throws {
		guard let reachabilityInstance = hostname.withCString ({
			return SCNetworkReachabilityCreateWithName(nil, $0)
		}) else {
			throw Error.UnableToCreateWithHostname(hostname)
		}
		try self.init(reachability: reachabilityInstance, callbackQueue: callbackQueue)
	}

	public convenience init(address anAddress: sockaddr_in, callbackQueue: dispatch_queue_t = DispatchQueue.Main) throws {
		var address = anAddress
		guard let reachabilityInstance = withUnsafePointer(&address, {
			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
		}) else {
			throw Error.UnableToCreateWithAddress(address)
		}
		try self.init(reachability: reachabilityInstance, callbackQueue: callbackQueue)
	}

	public convenience init(connectionType: ConnectionType, callbackQueue: dispatch_queue_t = DispatchQueue.Main) throws {
		var address = sockaddr_in()
		address.sin_len = __uint8_t(sizeofValue(address))
		address.sin_family = sa_family_t(AF_INET)

		switch connectionType {
		case .InternetConnection: break
		case .LocalWiFi:
			// IN_LINKLOCALNETNUM is defined in <netinet/in.h> as 169.254.0.0.
			let localLinkAddress: UInt32 = 0xA9FE0000
			address.sin_addr.s_addr = in_addr_t(localLinkAddress.bigEndian)
		}
		try self.init(address: address, callbackQueue: callbackQueue)
	}

	deinit {
    stopMonitoring()
	}

	// MARK: -

	public func startMonitoring() throws {
		guard !monitoringRunning else {
			return
		}
		let info = UnsafeMutablePointer<Void>(unsafeAddressOf(self))
		var context = SCNetworkReachabilityContext(version: 0, info: info, retain: nil, release: nil, copyDescription: nil)
		guard SCNetworkReachabilitySetCallback(reachability, NetworkReachabilityCallBack, &context) else {
			stopMonitoring()
			throw Error.UnableToSetCallback
		}
		guard SCNetworkReachabilitySetDispatchQueue(reachability, reachabilityDispatchQueue) else {
			stopMonitoring()
			throw Error.UnableToSetDispatchQueue
		}
		dispatch_async(reachabilityDispatchQueue) { [weak self] in guard let s = self else { return }
			s.reachabilityChangedWithFlags(s.reachabilityFlags)
		}
		monitoringRunning = true
	}

	public func stopMonitoring() {
		defer {
			monitoringRunning = false
		}
		SCNetworkReachabilitySetCallback(reachability, nil, nil)
		SCNetworkReachabilitySetDispatchQueue(reachability, nil)
	}

	// MARK: -

	public static func reachabilityFlags(hostname hostname: String) throws -> SCNetworkReachabilityFlags {
		guard let reachabilityInstance = hostname.withCString ({
			return SCNetworkReachabilityCreateWithName(nil, $0)
		}) else {
			throw Error.UnableToCreateWithHostname(hostname)
		}
		return reachabilityFlags(reachabilityInstance)
	}

	// MARK: - Private

	private func reachabilityChangedWithFlags(flags: SCNetworkReachabilityFlags) {
		defer {
			previousFlags = flags
		}
		guard previousFlags != flags else {
			return
		}

		dispatch_async(callbackQueue) { [weak self] in
			self?.reachabilityChanged?(flags)
		}
	}

	private static func reachabilityFlags(reachability: SCNetworkReachability) -> SCNetworkReachabilityFlags {
		var flags = SCNetworkReachabilityFlags()
		let gotFlags = withUnsafeMutablePointer(&flags) {
			SCNetworkReachabilityGetFlags(reachability, $0)
		}
		return gotFlags ? flags : SCNetworkReachabilityFlags()
	}

}
