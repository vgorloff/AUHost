//
//  VULevelMeter.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 26.01.16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

import AppKit
import GLKit
import MetalKit

private let gUseInternalCustomDrawTimer = false

@available(OSX 10.11, *)
public final class VULevelMeter: MTKView {

   enum Error: Swift.Error {
      case unableToInitialize(String)
   }

   public var numberOfChannels: UInt32 = 1
   public var level = Array(repeating: Float(0), count: 1) {
      didSet {
         if gUseInternalCustomDrawTimer {
            needsDisplay = true
         }
         assert(UInt32(level.count) >= numberOfChannels)
      }
   }

   private typealias SelfClass = VULevelMeter

   private let pixelFormat = MTLPixelFormat.bgra8Unorm // Actually it is default value
   private var defaultLibrary: MTLLibrary!
   fileprivate var commandQueue: MTLCommandQueue!
   fileprivate var pipelineState: MTLRenderPipelineState!
   fileprivate var dataBufferProvider: BufferDatasource!
   fileprivate let modelDatasource = ModelDatasource()

   public override init(frame: CGRect, device: MTLDevice?) {
      super.init(frame: frame, device: device)
      initialize()
   }

   public required init(coder: NSCoder) {
      super.init(coder: coder)
      initialize()
   }

   // MARK: • Private

   private func initialize() {
      do {
         try initializeMetal()
      } catch {
         Logger.error(subsystem: .media, category: .initialise, message: error)
      }
   }

   private func initializeMetal() throws {
      guard let metalDevice = MTLCreateSystemDefaultDevice() else {
         throw Error.unableToInitialize(String(describing: MTLDevice.self))
      }
      device = metalDevice
      commandQueue = metalDevice.makeCommandQueue()
      let metalLibraryURL = try Bundle(for: SelfClass.self).urlForResource(resourceName: "default", resourceExtension: "metallib")
      let library = try metalDevice.makeLibrary(filepath: metalLibraryURL.path)
      defaultLibrary = library
      pipelineState = try setUpPipeline(metalDevice: metalDevice, pixelFormat: pixelFormat)
      clearColor = MTLClearColorMake(0, 0, 1, 1)
      colorPixelFormat = pixelFormat
      // We will use external timer.
      isPaused = gUseInternalCustomDrawTimer
      enableSetNeedsDisplay = gUseInternalCustomDrawTimer
      dataBufferProvider = BufferDatasource(device: metalDevice, inFlightBuffersCount: 3)
   }

   private func setUpPipeline(metalDevice: MTLDevice, pixelFormat: MTLPixelFormat) throws -> MTLRenderPipelineState {
      guard let vertexProgram = defaultLibrary.makeFunction(name: "vertex_line") else {
         throw Error.unableToInitialize(String(describing: MTLFunction.self))
      }
      guard let fragmentProgram = defaultLibrary.makeFunction(name: "fragment_line") else {
         throw Error.unableToInitialize(String(describing: MTLFunction.self))
      }

      let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
      pipelineStateDescriptor.vertexFunction = vertexProgram
      pipelineStateDescriptor.fragmentFunction = fragmentProgram
      // Alternatively can be set from drawable.texture.pixelFormat
      pipelineStateDescriptor.colorAttachments[0].pixelFormat = pixelFormat
      return try metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
   }

   public override func draw(_ dirtyRect: NSRect) {
      if !inLiveResize {
         autoreleasepool { [unowned self] in
            do {
               try self.render()
            } catch let error {
               Logger.error(subsystem: .media, category: .initialise, message: error)
            }
         }
      }
   }
}

@available(OSX 10.11, *)
extension VULevelMeter {

   private func prepareRenderCommandEncoder(encoder: MTLRenderCommandEncoder, drawable: CAMetalDrawable) throws {

      let drawableSize = drawable.layer.drawableSize
      let levelL = min(1, level[0]).CGFloatValue

      let w = Float(drawableSize.width * levelL)
      let h = Float(drawableSize.height * levelL)

      //OpenGL’s normalized z-coordinate system ranges from -1 to 1, while Metal’s is only 0 to 1.
      let projectionMatrix = GLKMatrix4MakeOrtho(0, w, h, 0, -1, 1)

      modelDatasource.reset(xOffset: 0, yOffset: 0, width: Double(w), height: Double(h))
      for x in 0 ..< Int(w) where x % 4 != 0 {
         modelDatasource.addVerticalLine(xPosition: Double(x))
      }
      for y in 0 ..< Int(h) where y % 4 != 0 {
         modelDatasource.addHorizontalLine(yPosition: Double(y))
      }

      guard modelDatasource.floatVertices.count > 0 else {
         return
      }

      let color = NSColor.red
      var componentR: CGFloat = 0
      var componentG: CGFloat = 0
      var componentB: CGFloat = 0
      color.getRed(&componentR, green: &componentG, blue: &componentB, alpha: nil)
      let colorData = [Float(componentR), Float(componentG), Float(componentB)]

      let buffers = try dataBufferProvider.nextBuffers(vertices: modelDatasource.floatVertices,
                                                       color: colorData, matrix: projectionMatrix.data())
      encoder.setVertexBuffer(buffers.position, offset: 0, index: 0)
      encoder.setVertexBuffer(buffers.color, offset: 0, index: 1)
      encoder.setVertexBuffer(buffers.projectionMatrix, offset: 0, index: 2)
      encoder.drawPrimitives(type: .line, vertexStart: 0, vertexCount: modelDatasource.floatVertices.count / 2)
   }

   private func render() throws {

      guard let currentDrawable = currentDrawable else {
         throw Error.unableToInitialize(String(describing: CAMetalDrawable.self))
      }

      guard let renderPassDescriptor = currentRenderPassDescriptor else {
         throw Error.unableToInitialize(String(describing: MTLRenderPassDescriptor.self))
      }

      guard let commandBuffer = commandQueue.makeCommandBuffer() else {
         throw Error.unableToInitialize(String(describing: MTLCommandBuffer.self))
      }

      guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
         throw Error.unableToInitialize(String(describing: MTLRenderCommandEncoder.self))
      }

      do {
         dataBufferProvider.dispatchWait()
         commandBuffer.label = "Main Command Buffer"
         commandBuffer.addCompletedHandler { [unowned self] _ -> Void in
            self.dataBufferProvider.dispatchSignal()
         }

         renderEncoder.label = "Final Pass Encoder"
         renderEncoder.pushDebugGroup("Drawing buffers")
         renderEncoder.setRenderPipelineState(pipelineState)
         try prepareRenderCommandEncoder(encoder: renderEncoder, drawable: currentDrawable)
         renderEncoder.popDebugGroup()
         renderEncoder.endEncoding()

         commandBuffer.present(currentDrawable)
         commandBuffer.commit()
      } catch {
         dataBufferProvider.dispatchSignal()
         throw error
      }
   }
}
