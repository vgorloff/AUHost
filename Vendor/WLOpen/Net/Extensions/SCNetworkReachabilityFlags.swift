//
//  SCNetworkReachabilityFlags.swift
//  WLNet
//
//  Created by Vlad Gorlov on 08.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import SystemConfiguration

extension SCNetworkReachabilityFlags: CustomDebugStringConvertible {

	// - SeeAlso: [ Discern, Design, Generate › Network Reachability ]( http://blog.ddg.com/?p=24 )
	// iPhone condition codes as reported by a 3GS running iPhone OS v3.0.
	// Airplane Mode turned on:  Reachability Flag Status: -- -------
	// WWAN Active:              Reachability Flag Status: WR -t-----
	// WWAN Connection required: Reachability Flag Status: WR ct-----
	//       WiFi on: Reachability Flag Status: -R ------- Reachable.
	// Local WiFi on: Reachability Flag Status: -R xxxxxxd Reachable.
	//       WiFi on: Reachability Flag Status: -R ct----- Connection down. (Empirically determined answer.)
	//       WiFi on: Reachability Flag Status: -R ct-i--- Reachable but it require user intervention (e.g. enter a WiFi password).
	//       WiFi on: Reachability Flag Status: -R -t----- Reachable via VPN.
	//
	// In the below method, an 'x' in the flag status means I don't care about its value.
	public var debugDescription: String {
		#if os(iOS)
		let W = isOnWWAN ? "W" : "-"
		#else
		let W = "X"
		#endif
		let R = isReachable ? "R" : "-"
		let t = isTransientConnection ? "t" : "-"
		let c = isConnectionRequired ? "c" : "-"
		let C = isConnectionOnTraffic ? "C" : "-"
		let i = isInterventionRequired ? "i" : "-"
		let D = isConnectionOnDemand ? "D" : "-"
		let l = isLocalAddress ? "l" : "-"
		let d = isDirect ? "d" : "-"
		return "\(W)\(R) \(c)\(t)\(i)\(C)\(D)\(l)\(d)"
	}
}

public extension SCNetworkReachabilityFlags {
	public var isTransientConnection: Bool {
		return contains(.TransientConnection)
	}
	public var isReachable: Bool {
		return contains(.Reachable)
	}
	public var isConnectionRequired: Bool {
		return contains(.ConnectionRequired)
	}
	public var isConnectionOnTraffic: Bool {
		return contains(.ConnectionOnTraffic)
	}
	public var isInterventionRequired: Bool {
		return contains(.InterventionRequired)
	}
	public var isConnectionOnDemand: Bool {
		return contains(.ConnectionOnDemand)
	}
	public var isLocalAddress: Bool {
		return contains(.IsLocalAddress)
	}
	public var isDirect: Bool {
		return contains(.IsDirect)
	}

	#if os(iOS)
	public var isOnWWAN: Bool {
		return contains(.IsWWAN)
	}

	public var isReachableViaWWAN: Bool {
		return isReachableViaNetwork && isOnWWAN
	}

	public var isReachableViaWiFi: Bool {
		return isReachableViaNetwork && !isOnWWAN
	}
	#else
	public var isReachableViaWiFi: Bool {
		return isReachableViaNetwork
	}
	#endif

	public var isReachableViaLocalWiFi: Bool {
		return isReachable && isDirect
	}

	public var isReachableViaNetwork: Bool {
		guard isReachable else {
			return false
		}
		var returnValue = false
		if !isConnectionRequired {
			returnValue = true
		}
		if isConnectionOnDemand || isConnectionOnTraffic {
			if !isInterventionRequired {
				returnValue = true
			}
		}
		return returnValue
	}
}
