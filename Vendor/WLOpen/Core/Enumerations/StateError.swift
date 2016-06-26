//
//  StateError.swift
//  WLCore
//
//  Created by Vlad Gorlov on 06.02.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public enum StateError: ErrorType {
	case UnableToInitialize(String)
	case NotInitialized(String)
	case ResourceIsNotAvailable(String)
}
