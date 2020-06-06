//
//  UIImage.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcUI
import UIKit

extension UIImage {

   public convenience init?(named: String, in bundle: Bundle) {
      self.init(named: named, in: bundle, compatibleWith: nil)
   }

   /// Instantiate UIImage or nil if data is nil or image canot be instantiated.
   /// - parameter dataOrNil: Image data or nil.
   public convenience init?(dataOrNil: Data?) {
      if let d = dataOrNil {
         self.init(data: d)
      } else {
         return nil
      }
   }
}

extension UIImage {

   /// - SeeAlso: [https://github.com/mbcharbonneau/UIImage-Categories/blob/master/UIImage%2BAlpha.m]
   public var hasAlpha: Bool {
      guard let alpha = cgImage?.alphaInfo else {
         return false
      }
      return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
   }

   public func jpegData(compressedTo size: Int) -> Data? {
      var result: Data?
      for compression in stride(from: CGFloat(1), through: 0.1, by: -0.1) {
         guard let imageData = jpegData(compressionQuality: compression) else {
            return nil
         }
         if imageData.count < size {
            result = imageData
            break
         }
      }
      return result
   }
}

extension UIImage {

   public func blurred(withRadius radius: CGFloat) -> UIImage? {

      guard
         let inputImage = CIImage(image: self),
         let blurFilter = CIFilter(name: "CIGaussianBlur"),
         let clampFilter = CIFilter(name: "CIAffineClamp")
      else {
         return nil
      }

      clampFilter.setDefaults()
      clampFilter.setValue(inputImage, forKey: kCIInputImageKey)

      blurFilter.setValue(clampFilter.outputImage, forKey: kCIInputImageKey)
      blurFilter.setValue(radius, forKey: kCIInputRadiusKey)

      let context = CIContext(options: nil)
      guard let result = blurFilter.outputImage, let cgImage = context.createCGImage(result, from: inputImage.extent) else {
         return nil
      }
      return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
   }
}

extension UIImage {

   // http://stackoverflow.com/a/10611036/1418981
   public func fixOrientation() -> UIImage? {

      // No-op if the orientation is already correct
      if imageOrientation == .up {
         return self
      }

      // We need to calculate the proper transformation to make the image upright.
      // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
      var transform = CGAffineTransform.identity

      if imageOrientation == .down || imageOrientation == .downMirrored {
         transform = transform.translatedBy(x: size.width, y: size.height)
         transform = transform.rotated(by: CGFloat.pi)
      }

      if imageOrientation == .left || imageOrientation == .leftMirrored {
         transform = transform.translatedBy(x: size.width, y: 0)
         transform = transform.rotated(by: CGFloat(Float.pi / 2))
      }

      if imageOrientation == .right || imageOrientation == .rightMirrored {
         transform = transform.translatedBy(x: 0, y: size.height)
         transform = transform.rotated(by: -CGFloat(Float.pi / 2))
      }

      if imageOrientation == .upMirrored || imageOrientation == .downMirrored {
         transform = transform.translatedBy(x: size.width, y: 0)
         transform = transform.scaledBy(x: -1, y: 1)
      }

      if imageOrientation == .leftMirrored || imageOrientation == .rightMirrored {
         transform = transform.translatedBy(x: size.height, y: 0)
         transform = transform.scaledBy(x: -1, y: 1)
      }

      // Now we draw the underlying CGImage into a new context, applying the transform
      // calculated above.
      guard let cgImage = cgImage, let colorSpace = cgImage.colorSpace,
         let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                             bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace,
                             bitmapInfo: cgImage.bitmapInfo.rawValue)
      else {
         return nil
      }

      ctx.concatenate(transform)

      if imageOrientation == .left || imageOrientation == .leftMirrored ||
         imageOrientation == .right || imageOrientation == .rightMirrored {
         ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
      } else {
         ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
      }

      // And now we just create a new UIImage from the drawing context and return it
      guard let image = ctx.makeImage() else {
         return nil
      }
      return UIImage(cgImage: image)
   }
}
#endif
