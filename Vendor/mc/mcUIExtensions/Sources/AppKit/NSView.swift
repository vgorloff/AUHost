//
//  NSView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
import mcRuntime
import mcUI

extension NSView {

   public var accessibilityId: String? {
      get {
         return accessibilityIdentifier()
      } set {
         setAccessibilityIdentifier(newValue)
      }
   }

   public var isVisible: Bool {
      get {
         return !isHidden
      } set {
         isHidden = !newValue
      }
   }

   public func convertFromBacking(_ value: CGFloat) -> CGFloat {
      return convertFromBacking(NSSize(width: value, height: value)).width
   }

   public func convertToBacking(_ value: CGFloat) -> CGFloat {
      return convertToBacking(NSSize(width: value, height: value)).width
   }

   public func addSubviews(_ views: NSView...) {
      for view in views {
         addSubview(view)
      }
   }

   public func addSubviews(_ views: [NSView]) {
      for view in views {
         addSubview(view)
      }
   }

   public func removeSubviews() {
      subviews.forEach { $0.removeFromSuperview() }
   }

   public var recursiveSubviews: [NSView] {
      var result = subviews
      for subview in subviews {
         result += subview.recursiveSubviews
      }
      return result
   }

   public var controls: [NSControl] {
      return subviews.compactMap { $0 as? NSControl }
   }

   public var recursiveControls: [NSControl] {
      var result = controls
      for subview in subviews {
         result += subview.recursiveControls
      }
      return result
   }

   public func recursiveSubviews<T: NSView>(for type: T.Type) -> [T] {
      return recursiveSubviews.compactMap { $0 as? T }
   }

   public func withFocus(drawingCalls: () -> Void) {
      lockFocus()
      drawingCalls()
      unlockFocus()
   }
}

extension NSView {

   /// - fittingSizeCompression: 50
   /// - defaultLow: 250
   /// - dragThatCannotResizeWindow: 490
   /// - windowSizeStayPut: 500
   /// - dragThatCanResizeWindow: 510
   /// - defaultHigh: 750
   /// - required: 1000
   public var verticalContentCompressionResistancePriority: NSLayoutConstraint.Priority {
      get {
         return contentCompressionResistancePriority(for: .vertical)
      } set {
         setContentCompressionResistancePriority(newValue, for: .vertical)
      }
   }

   /// - fittingSizeCompression: 50
   /// - defaultLow: 250
   /// - dragThatCannotResizeWindow: 490
   /// - windowSizeStayPut: 500
   /// - dragThatCanResizeWindow: 510
   /// - defaultHigh: 750
   /// - required: 1000
   public var horizontalContentCompressionResistancePriority: NSLayoutConstraint.Priority {
      get {
         return contentCompressionResistancePriority(for: .horizontal)
      } set {
         setContentCompressionResistancePriority(newValue, for: .horizontal)
      }
   }

   /// - fittingSizeCompression: 50
   /// - defaultLow: 250
   /// - dragThatCannotResizeWindow: 490
   /// - windowSizeStayPut: 500
   /// - dragThatCanResizeWindow: 510
   /// - defaultHigh: 750
   /// - required: 1000
   public var verticalContentHuggingPriority: NSLayoutConstraint.Priority {
      get {
         return contentHuggingPriority(for: .vertical)
      } set {
         setContentHuggingPriority(newValue, for: .vertical)
      }
   }

   /// - fittingSizeCompression: 50
   /// - defaultLow: 250
   /// - dragThatCannotResizeWindow: 490
   /// - windowSizeStayPut: 500
   /// - dragThatCanResizeWindow: 510
   /// - defaultHigh: 750
   /// - required: 1000
   public var horizontalContentHuggingPriority: NSLayoutConstraint.Priority {
      get {
         return contentHuggingPriority(for: .horizontal)
      } set {
         setContentHuggingPriority(newValue, for: .horizontal)
      }
   }

   // MARK: -

   public var systemAppearance: SystemAppearance {
      if #available(OSX 10.14, *) {
         return effectiveAppearance.systemAppearance
      } else {
         // See: https://stackoverflow.com/q/51774587/1418981
         if NSWorkspace.shared.accessibilityDisplayShouldIncreaseContrast {
            return .highContrastLight
         } else {
            return .light
         }
      }
   }
}

extension NSView {

   public func setNeedsLayout() {
      needsLayout = true
   }

   public func layoutIfNeeded() {
      if needsLayout {
         layout()
      }
   }

   public func sizeToFittingSize() {
      frame = CGRect(origin: frame.origin, size: fittingSize)
   }

   public func autolayoutView() -> Self {
      translatesAutoresizingMaskIntoConstraints = false
      return self
   }

   public func autoresizingView() -> Self {
      translatesAutoresizingMaskIntoConstraints = true
      return self
   }

   /// Prints results of internal Apple API method `_subtreeDescription` to console.
   public func dump() {
      let value = perform(Selector(("_subtreeDescription")))
      Swift.print(String(describing: value))
   }

   public func autolayoutTrace() {
      let value = perform(Selector(("_autolayoutTrace")))
      Swift.print(String(describing: value))
   }

   public var ambiguousSubviews: [NSView] {
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
            print("- " + $0.debugDescription)
            $0.autolayoutTrace()
         }
         if RuntimeInfo.shouldAssertOnAmbiguousLayout {
            assert(value.isEmpty)
         }
      }
   }
}

extension NSView {

   public var anchor: LayoutConstraint {
      return LayoutConstraint()
   }
}
#endif
