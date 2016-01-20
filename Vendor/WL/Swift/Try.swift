//
//  Try.swift
//  AUHost
//
//  Created by Volodymyr Gorlov on 20.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

public struct Try {
	public static func with<T>(@noescape closure: () throws -> T) -> ResultType<T> {
		do {
			return ResultType.Success(try closure())
		} catch {
			return ResultType.Failure(error)
		}
	}
}
