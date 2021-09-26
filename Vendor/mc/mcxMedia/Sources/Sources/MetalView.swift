//
//  MetalView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

import Foundation
import MetalKit

open class MetalView: MTKView {

   public enum Error: Swift.Error {
      case unableToInitialize(String)
   }

   private var metalSetup: MetalSetup?
   public private(set) var viewportSize = vector_float2(100, 100)

   public init() {
      let device = MTLCreateSystemDefaultDevice()
      super.init(frame: .zero, device: device)

      clearColor = MTLClearColorMake(0, 0, 0, 0) // Clear color. See: https://forums.developer.apple.com/thread/26461
      #if canImport(UIKit)
      backgroundColor = .clear // Not really needed, but why not.
      layer.isOpaque = false // Transparent Metal background:  See: https://stackoverflow.com/q/37144060/1418981
      #else
      layer?.isOpaque = false // Transparent Metal background:  See: https://stackoverflow.com/q/37144060/1418981
      #endif

      isPaused = false
      enableSetNeedsDisplay = false
      do {
         if let device = device {
            let metalSetup = try MetalSetup(device: device, functions: functions)
            colorPixelFormat = metalSetup.pixelFormat
            metalSetup.delegate = self
            self.metalSetup = metalSetup
            delegate = self
         } else {
            throw MetalSetup.Error.unableToInitialize(String(describing: MTLDevice.self))
         }
      } catch {
         log.error(.drawing, error)
      }
   }

   @available(*, unavailable)
   public required init(coder: NSCoder) {
      fatalError()
   }

   open func drawableSizeWillChange(size: CGSize) {
      // Base class does nothing.
   }

   open func prepareEncoder(id: String, device: MTLDevice, encoder: MTLRenderCommandEncoder) throws {
      // Base class does nothing.
   }

   open var functions: [MetalSetup.Functions] {
      fatalError("Not implemented")
   }
}

extension MetalView: MTKViewDelegate {

   public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
      viewportSize.x = Float(size.width)
      viewportSize.y = Float(size.height)
      drawableSizeWillChange(size: size)
      log.trace("Size changed: \(size)")
   }

   public func draw(in view: MTKView) {
      #if canImport(AppKit) && !targetEnvironment(macCatalyst)
      if inLiveResize {
         return
      }
      #endif
      if let drawable = currentDrawable, let setup = metalSetup, let descriptor = currentRenderPassDescriptor {
         autoreleasepool {
            do {
               try setup.render(drawable: drawable, renderPassDescriptor: descriptor)
            } catch {
               log.error(.drawing, error)
            }
         }
      }
   }
}

extension MetalView: MetalSetupDelegate {

   func prepareEncoder(id: String, encoder: MTLRenderCommandEncoder, drawable: CAMetalDrawable, bufferDataSource: BufferDatasource) throws {
      guard let setup = metalSetup else {
         return
      }
      try bufferDataSource.nextBuffers {
         let width = Double(viewportSize.x)
         let height = Double(viewportSize.y)
         let viewPort = MTLViewport(originX: 0, originY: 0, width: width, height: height, znear: 0, zfar: 1)
         encoder.setViewport(viewPort)
         try prepareEncoder(id: id, device: setup.device, encoder: encoder)
      }
   }
}
