//
//  UIView+Layout.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcFoundationLogging
import mcRuntime
import UIKit

private let tracer = Log<AppLogCategory>(subsystem: "ui")

extension UIView {

   public func dump() {
      print(perform(Selector(("recursiveDescription"))) as Any)
   }

   public var autolayoutTrace: String? {
      if let window = window {
         let trace = String(describing: window.perform(Selector(("_autolayoutTrace")))) + "\n"
         return trace
      }
      return nil
   }

   public var ambiguousSubviews: [UIView] {
      guard BuildInfo.isDebug else {
         return []
      }
      let result = recursiveSubviews.filter { $0.hasAmbiguousLayout }
      return result
   }

   public func assertOnAmbiguityInSubviewsLayout() {
      guard BuildInfo.isDebug else {
         return
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
         let value = self.ambiguousSubviews
         value.forEach {
            if let trace = $0.autolayoutTrace {
               tracer.trace(trace, shouldSaveToFile: true)
            }
         }
         if RuntimeInfo.shouldAssertOnAmbiguousLayout {
            assert(value.isEmpty)
         }
      }
   }

   public var verticalContentCompressionResistancePriority: UILayoutPriority {
      get {
         return contentCompressionResistancePriority(for: .vertical)
      } set {
         setContentCompressionResistancePriority(newValue, for: .vertical)
      }
   }

   public var horizontalContentCompressionResistancePriority: UILayoutPriority {
      get {
         return contentCompressionResistancePriority(for: .horizontal)
      } set {
         setContentCompressionResistancePriority(newValue, for: .horizontal)
      }
   }

   public var verticalContentHuggingPriority: UILayoutPriority {
      get {
         return contentHuggingPriority(for: .vertical)
      } set {
         setContentHuggingPriority(newValue, for: .vertical)
      }
   }

   public var horizontalContentHuggingPriority: UILayoutPriority {
      get {
         return contentHuggingPriority(for: .horizontal)
      } set {
         setContentHuggingPriority(newValue, for: .horizontal)
      }
   }
}

extension UIView {

   public func removeAllConstraints() {
      removeConstraints(constraints)
   }

   public func autolayoutView() -> Self {
      translatesAutoresizingMaskIntoConstraints = false
      return self
   }

   public func autoresizingView() -> Self {
      translatesAutoresizingMaskIntoConstraints = true
      return self
   }

   public func systemLayoutSizeFitting(targetSize: CGSize, horizontalFitting: UILayoutPriority,
                                       verticalFitting: UILayoutPriority) -> CGSize {
      return systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFitting,
                                     verticalFittingPriority: verticalFitting)
   }

   public func systemLayoutSizeFitting(width: Int, verticalFitting: UILayoutPriority) -> CGSize {
      let targetSize = CGSize(width: width, height: 0)
      return systemLayoutSizeFitting(targetSize: targetSize, horizontalFitting: .required, verticalFitting: verticalFitting)
   }

   public func systemLayoutSizeFitting(width: CGFloat, verticalFitting: UILayoutPriority) -> CGSize {
      let targetSize = CGSize(width: width, height: 0)
      return systemLayoutSizeFitting(targetSize: targetSize, horizontalFitting: .required, verticalFitting: verticalFitting)
   }

   public func systemLayoutSizeFitting(height: Int, horizontalFitting: UILayoutPriority) -> CGSize {
      let targetSize = CGSize(width: 0, height: height)
      return systemLayoutSizeFitting(targetSize: targetSize, horizontalFitting: horizontalFitting, verticalFitting: .required)
   }

   public func systemLayoutSizeFitting(height: CGFloat, horizontalFitting: UILayoutPriority) -> CGSize {
      let targetSize = CGSize(width: 0, height: height)
      return systemLayoutSizeFitting(targetSize: targetSize, horizontalFitting: horizontalFitting, verticalFitting: .required)
   }

   public func sizeToFit(width: CGFloat) {
      let orgin = frame.origin
      let tmpValue = translatesAutoresizingMaskIntoConstraints
      translatesAutoresizingMaskIntoConstraints = false
      setNeedsLayout()
      layoutIfNeeded()
      let size = systemLayoutSizeFitting(width: width, verticalFitting: .fittingSizeLevel)
      frame = CGRect(origin: orgin, size: size)
      translatesAutoresizingMaskIntoConstraints = tmpValue
   }

   public func sizeToFitSystemLayoutSize() {
      let orgin = frame.origin
      let size = systemLayoutSizeFitting(.zero)
      let tmpValue = translatesAutoresizingMaskIntoConstraints
      translatesAutoresizingMaskIntoConstraints = false
      frame = CGRect(origin: orgin, size: size)
      setNeedsLayout()
      layoutIfNeeded()
      translatesAutoresizingMaskIntoConstraints = tmpValue
   }
}
#endif
