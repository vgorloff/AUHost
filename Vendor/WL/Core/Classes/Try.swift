//
//  Try.swift
//  WLCore
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
	public static func log<T>(@autoclosure closure: () throws -> T) -> T? {
		do {
			return try closure()
		} catch {
			print(error)
			return nil
		}
	}
	public static func log<T>(@noescape closure: () throws -> T) -> T? {
		do {
			return try closure()
		} catch {
			print(error)
			return nil
		}
	}
}
