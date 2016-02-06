//
//  Process.swift
//  WLCore
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public extension Process {

	/// Path to original script before compilation
	public static var scriptFilePath: String?

	public static var executableFilePath: String {
		return scriptFilePath ?? arguments[0]
	}

	public static var executableFileName: String {
		return (scriptFilePath ?? arguments[0]).lastPathComponent
	}

	public static var executableDirectoryPath: String {
		return executableFilePath.stringByDeletingLastPathComponent
	}

}
