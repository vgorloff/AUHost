//
//  ResultType.swift
//  WLCore
//
//  Created by Volodymyr Gorlov on 09.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public enum ResultType<T> {
	case Success(T)
	case Failure(ErrorType)
}
