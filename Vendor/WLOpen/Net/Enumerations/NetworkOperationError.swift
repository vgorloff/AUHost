//
//  NetworkOperationError.swift
//  WLNet
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import Foundation

public enum NetworkOperationError: ErrorType {
	case NotInitializedURL
	case IncompleteDictionary(NSDictionary)
	case MissedAttribute(String)
	case InvalidOperationState
}
