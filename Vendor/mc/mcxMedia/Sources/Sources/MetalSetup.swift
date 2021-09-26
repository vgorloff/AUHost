//
//  MetalSetup.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import MetalKit

protocol MetalSetupDelegate: AnyObject {
   func prepareEncoder(id: String, encoder: MTLRenderCommandEncoder,
                       drawable: CAMetalDrawable, bufferDataSource: BufferDatasource) throws
}

public class MetalSetup {

   public struct Functions {

      let id: String
      let vertex: String
      let fragment: String

      public init(id: String = "default", vertex: String, fragment: String) {
         self.id = id
         self.vertex = vertex
         self.fragment = fragment
      }
   }

   public enum Error: Swift.Error {
      case unableToInitialize(String)
   }

   let device: MTLDevice
   let library: MTLLibrary
   let pixelFormat = MTLPixelFormat.bgra8Unorm // Actually it is default value
   let commandQueue: MTLCommandQueue
   private var pipelineStates: [String: MTLRenderPipelineState] = [:]
   let bufferDataSource: BufferDatasource
   weak var delegate: MetalSetupDelegate?

   public convenience init(device: MTLDevice, functions: Functions) throws {
      try self.init(device: device, functions: [functions])
   }

   public init(device: MTLDevice, functions: [Functions]) throws {
      self.device = device
      guard let url = Bundle(for: type(of: self)).url(forResource: "default", withExtension: "metallib") else {
         throw Error.unableToInitialize(String(describing: URL.self))
      }
      library = try device.makeLibrary(filepath: url.path)
      guard let commandQueue = device.makeCommandQueue() else {
         throw Error.unableToInitialize(String(describing: MTLCommandQueue.self))
      }
      self.commandQueue = commandQueue
      bufferDataSource = BufferDatasource(inFlightBuffersCount: 3)

      for function in functions {
         guard let vertexProgram = library.makeFunction(name: function.vertex) else {
            throw Error.unableToInitialize(String(describing: MTLFunction.self))
         }
         guard let fragmentProgram = library.makeFunction(name: function.fragment) else {
            throw Error.unableToInitialize(String(describing: MTLFunction.self))
         }

         let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
         pipelineStateDescriptor.vertexFunction = vertexProgram
         pipelineStateDescriptor.fragmentFunction = fragmentProgram
         // Alternatively can be set from drawable.texture.pixelFormat
         pipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
         let pipelineState = try device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
         pipelineStates[function.id] = pipelineState
      }
   }

   func render(drawable: CAMetalDrawable, renderPassDescriptor: MTLRenderPassDescriptor) throws {

      guard let delegate = delegate else {
         return
      }

      guard let commandBuffer = commandQueue.makeCommandBuffer() else {
         throw Error.unableToInitialize(String(describing: MTLCommandBuffer.self))
      }

      // Transparent Metal background. See: https://forums.developer.apple.com/thread/26461
      renderPassDescriptor.colorAttachments[0].loadAction = .clear

      guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
         throw Error.unableToInitialize(String(describing: MTLRenderCommandEncoder.self))
      }

      do {
         bufferDataSource.dispatchWait()
         commandBuffer.label = "Main Command Buffer"
         commandBuffer.addCompletedHandler { [unowned self] _ -> Void in
            self.bufferDataSource.dispatchSignal()
         }

         renderEncoder.label = "Final Pass Encoder"
         for (id, pipelineState) in pipelineStates {
            renderEncoder.pushDebugGroup("Drawing buffers for id: \(id)")
            renderEncoder.setRenderPipelineState(pipelineState)
            try delegate.prepareEncoder(id: id, encoder: renderEncoder, drawable: drawable, bufferDataSource: bufferDataSource)
            renderEncoder.popDebugGroup()
         }

         renderEncoder.endEncoding()

         commandBuffer.present(drawable)
         commandBuffer.commit()
      } catch {
         renderEncoder.endEncoding()
         bufferDataSource.dispatchSignal()
         throw error
      }
   }
}
