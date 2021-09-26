//
//  UIView+Snapshot.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UIView {

   /// Multitreading notes: https://stackoverflow.com/a/10954342/1418981
   public func snapshot(scale: CGFloat = 0, isOpaque: Bool = false, backgroundColor: UIColor? = nil,
                        afterScreenUpdates: Bool = true) -> UIImage? {
      UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, scale)
      if let backgroundColor = backgroundColor {
         backgroundColor.setFill()
         UIRectFill(CGRect(size: bounds.size))
      }
      let status = drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
      assert(status)
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return image
   }

   public enum CASnapshotLayer: Int {
      case `default`, presentation, model
   }

   /// Technical Q&A QA1714: How do I take a screenshot of my app that contains both UIKit and Camera elements?:
   ///                       https://developer.apple.com/library/archive/qa/qa1714/_index.html
   /// Multitreading notes: https://stackoverflow.com/a/10954342/1418981
   ///
   /// The method drawViewHierarchyInRect:afterScreenUpdates: performs its operations on the GPU as much as possible
   /// In comparison, the method renderInContext: performs its operations inside of your app�s address space and does
   /// not use the GPU based process for performing the work.
   /// https://stackoverflow.com/a/25704861/1418981
   public func caSnapshot(scale: CGFloat = 0, isOpaque: Bool = false, backgroundColor: UIColor? = nil,
                          layer layerToUse: CASnapshotLayer = .default) -> UIImage? {
      var isSuccess = false
      UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, scale)
      if let context = UIGraphicsGetCurrentContext() {
         if let backgroundColor = backgroundColor {
            context.setFillColor(backgroundColor.cgColor)
            context.fill(CGRect(size: bounds.size))
         }
         let layerToRender: CALayer?
         switch layerToUse {
         case .default:
            layerToRender = layer
         case .model:
            layerToRender = layer.model()
         case .presentation:
            layerToRender = layer.presentation()
         }
         if let layer = layerToRender {
            isSuccess = true
            layer.render(in: context)
         }
      }
      let image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      return isSuccess ? image : nil
   }
}
#endif
