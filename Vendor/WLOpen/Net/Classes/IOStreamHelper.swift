//
//  IOStreamHelper.swift
//  WLNet
//
//  Created by Volodymyr Gorlov on 07.12.15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import Foundation

public final class IOStreamHelper: NSObject, NSStreamDelegate {

	private var _inputStream: NSInputStream
	private var _outputStream: NSOutputStream
	private var _numberOfOpenedStreams = 0
	private lazy var log: Logger = {[unowned self] in return Logger(sender: self, context: .Network)}()

	// MARK: -

	public var inputStream: NSInputStream {
		return _inputStream
	}
	public var outputStream: NSOutputStream {
		return _outputStream
	}
	public var numberOfOpenedStreams: Int {
		return _numberOfOpenedStreams
	}
	public var streamEventCallback: ((stream: NSStream, eventCode: NSStreamEvent) -> Void)?
	public var readDataCallback: ((data: NSData) -> Void)?

	// MARK: -

	public convenience init(service: NSNetService) throws {
		var anInputStream: NSInputStream?
		var anOutputStream: NSOutputStream?
		let streamsOpened = service.getInputStream(&anInputStream, outputStream: &anOutputStream)
		guard let iStream = anInputStream, let oStream = anOutputStream where streamsOpened == true else {
			throw StateError.NotInitialized("NSInputStream or NSOutputStream")
		}
		self.init(inputStream: iStream, outputStream: oStream)
		if !streamsOpened {
			log.logWarn("Unable to get streams from service: \(service)")
		}
	}

	public init(inputStream anInputStream: NSInputStream, outputStream anOutputStream: NSOutputStream) {
		_inputStream = anInputStream
		_outputStream = anOutputStream
		super.init()
		log.logInit()
	}

	deinit {
		closeStreams()
		log.logDeinit()
	}

	// MARK: -

	public func openStreams() {
		openStream(inputStream)
		openStream(outputStream)
	}

	public func closeStreams() {
		closeStream(inputStream)
		closeStream(outputStream)
	}

	public func sendData(data: NSData) -> Int {
		return outputStream.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
	}

	// MARK: - Private

	private func closeStream(stream: NSStream) {
		_numberOfOpenedStreams -= 1
		stream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
		stream.close()
		stream.delegate = nil
	}

	private func openStream(stream: NSStream) {
		stream.delegate = self
		stream.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
		stream.open()
		_numberOfOpenedStreams += 1
	}

	// MARK: - NSStreamDelegate

	public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
		switch eventCode {
		case NSStreamEvent.OpenCompleted:
			log.logVerbose("Stream opened: \(aStream)")
			break

		case NSStreamEvent.HasSpaceAvailable:
			assert(aStream == outputStream)

		case NSStreamEvent.HasBytesAvailable:
			assert(aStream == inputStream)

			let msg = NSMutableData()
			var buffer = Array<UInt8>(count: 512, repeatedValue: 0)
			while inputStream.hasBytesAvailable {
				let bytesRead = inputStream.read(&buffer, maxLength: buffer.count)
				if bytesRead <= 0 {
					// Do nothing; we'll handle EOF and error in the
					// NSStreamEventEndEncountered and NSStreamEventErrorOccurred case, respectively.
				} else {
					msg.appendBytes(buffer, length: bytesRead)
				}
			}
			if msg.length > 0 {
				if let cb = readDataCallback {
					cb(data: msg)
				}
			}

		case NSStreamEvent.ErrorOccurred:
			log.logError(aStream.streamError)

		case NSStreamEvent.EndEncountered:
			log.logVerbose("Stream end reached: \(aStream)")
			closeStreams()

		default:
			assert(false)
		}

		if let cb = streamEventCallback {
			cb(stream: aStream, eventCode: eventCode)
		}
	}
}
