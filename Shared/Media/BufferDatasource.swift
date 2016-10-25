//
//  BufferDatasource.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 22.11.15.
//  Copyright (c) 2015 Vlad Gorlov. All rights reserved.
//

import Foundation
import MetalKit

final class BufferDatasource {

   struct Buffers {
      var position: MTLBuffer
      var color: MTLBuffer
      var projectionMatrix: MTLBuffer
   }

   private struct CollectionOfBuffers {
      var position = [MTLBuffer]()
      var color = [MTLBuffer]()
      var projectionMatrix = [MTLBuffer]()

      func buffers(at index: Int) -> Buffers {
         return Buffers(position: position[index],
                        color: color[index],
                        projectionMatrix: projectionMatrix[index])
      }
   }

   private var inFlightSemaphore: DispatchSemaphore
   private var inFlightBuffersCount: Int
   private var buffers = CollectionOfBuffers()
   private var availableBufferIndex = 0
   private var device: MTLDevice

   init(device aDevice: MTLDevice, inFlightBuffersCount: Int) {
      inFlightSemaphore = DispatchSemaphore(value: inFlightBuffersCount)
      self.inFlightBuffersCount = inFlightBuffersCount
      device = aDevice
   }

   deinit {
      for _ in 0 ... inFlightBuffersCount {
         inFlightSemaphore.signal()
      }
   }

   func nextBuffers(vertices: [Float], color: [Float], matrix: [Float]) -> Buffers {

      let verticesDataSize = vertices.count * MemoryLayout<Float>.size
      let colorDataSize = color.count * MemoryLayout<Float>.size
      let matrixDataSize = matrix.count * MemoryLayout<Float>.size

      if buffers.position.count - 1 < availableBufferIndex {
         buffers.position.append(device.makeBuffer(length: verticesDataSize, options: []))
      }
      if buffers.color.count - 1 < availableBufferIndex {
         buffers.color.append(device.makeBuffer(length: colorDataSize, options: []))
      }
      if buffers.projectionMatrix.count - 1 < availableBufferIndex {
         buffers.projectionMatrix.append(device.makeBuffer(length: matrixDataSize, options: []))
      }

      var currentBuffers = buffers.buffers(at: availableBufferIndex)

      if currentBuffers.position.length != verticesDataSize {
         currentBuffers.position = device.makeBuffer(length: verticesDataSize, options: [])
         buffers.position[availableBufferIndex] = currentBuffers.position
      }
      if currentBuffers.color.length != colorDataSize {
         currentBuffers.color = device.makeBuffer(length: colorDataSize, options: [])
         buffers.color[availableBufferIndex] = currentBuffers.color
      }
      if currentBuffers.projectionMatrix.length != matrixDataSize {
         currentBuffers.projectionMatrix = device.makeBuffer(length: matrixDataSize, options: [])
         buffers.projectionMatrix[availableBufferIndex] = currentBuffers.projectionMatrix
      }

      memcpy(currentBuffers.position.contents(), vertices, verticesDataSize)
      memcpy(currentBuffers.color.contents(), color, colorDataSize)
      memcpy(currentBuffers.projectionMatrix.contents(), matrix, matrixDataSize)

      availableBufferIndex += 1
      if availableBufferIndex >= inFlightBuffersCount {
         availableBufferIndex = 0
      }

      return currentBuffers
   }

   func dispatchWait() {
      inFlightSemaphore.wait()
   }

   func dispatchSignal() {
      inFlightSemaphore.signal()
   }

}
