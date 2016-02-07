//
//  NSTask.swift
//  WLCore
//
//  Created by Vlad Gorlov on 25.10.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

public extension NSTask {
	public static func findExecutablePath(executableName: String) -> String? {
		if executableName.isEmpty {
			return nil
		}
		let task = NSTask()
		task.launchPath = "/bin/bash"
		task.arguments = ["-l", "-c", "which \(executableName)"]

		let outPipe = NSPipe()
		task.standardOutput = outPipe

		task.launch()
		task.waitUntilExit()

		return outPipe.readIntoString()
	}
}
