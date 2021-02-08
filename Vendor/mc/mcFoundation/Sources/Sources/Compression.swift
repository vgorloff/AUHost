//
//  Compression.swift
//  Playgrounds
//
//  Created by Vlad Gorlov on 29.06.20.
//

import Foundation
import Compression
import mcTypes

public enum CompressionAlgorithm: Int {
   case zlib
   fileprivate var value: compression_algorithm {
      switch self {
      case .zlib:
         return COMPRESSION_ZLIB
      }
   }
}

public enum CompressionError: Error {
   case unableToEncode, unableToDecode
}

public class CompressionDecoder {

   public let data: Data
   public let algorithm: CompressionAlgorithm

   private let destinationBufferSize: Int
   private lazy var sourceBufferSize = data.count

   public init(data: Data, sourceDataSize: Int, algorithm: CompressionAlgorithm = .zlib) {
      self.data = data
      self.algorithm = algorithm
      self.destinationBufferSize = sourceDataSize
   }

   public func decompress() throws -> Data {
      if data.count == 0 {
         return data
      }
      let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: destinationBufferSize)
      let decompressedSize = data.withUnsafeBytes { bytes -> Int? in
         if let address = bytes.bindMemory(to: UInt8.self).baseAddress {
            let size = compression_decode_buffer(destinationBuffer,
                                             destinationBufferSize,
                                             address,
                                             sourceBufferSize,
                                             nil,
                                             algorithm.value)
            return size == 0 ? nil : size
         } else {
            return nil
         }
      }

      if let decompressedSize = decompressedSize {
         let decodedData = Data(bytes: destinationBuffer, count: decompressedSize)
         destinationBuffer.deallocate()
         return decodedData
      } else {
         throw AppError<CompressionError>(.unableToDecode)
      }
   }

}

public class CompressionEncoder {

   public let data: Data
   public let algorithm: CompressionAlgorithm

   private let destinationBufferSize: Int
   private let sourceBufferSize: Int

   public init(data: Data, algorithm: CompressionAlgorithm = .zlib) {
      self.data = data
      self.algorithm = algorithm
      sourceBufferSize = data.count

      // See why multiplication is neded: https://stackoverflow.com/a/39849443/1418981
      if sourceBufferSize < 10 {
         destinationBufferSize = sourceBufferSize * 10
      } else if sourceBufferSize < 100 {
         destinationBufferSize = sourceBufferSize * 5
      } else {
         destinationBufferSize = sourceBufferSize * 2
      }
   }

   public func compress() throws -> Data {
      if data.count == 0 {
         return data
      }
      let destinationBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: destinationBufferSize)
      let compressedSize = data.withUnsafeBytes { bytes -> Int? in
         if let address = bytes.bindMemory(to: UInt8.self).baseAddress {
            let size = compression_encode_buffer(destinationBuffer,
                                             destinationBufferSize,
                                             address,
                                             sourceBufferSize,
                                             nil,
                                             algorithm.value)
            return size == 0 ? nil : size
         } else {
            return nil
         }
      }

      if let compressedSize = compressedSize {
         let encodedData = Data(bytes: destinationBuffer, count: compressedSize)
         destinationBuffer.deallocate()
         return encodedData
      } else {
         throw AppError<CompressionError>(.unableToEncode)
      }
   }
}
