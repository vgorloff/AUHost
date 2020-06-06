//
//  LayoutConstraint.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 04/05/16.
//  Copyright © 2016 Vlad Gorlov. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif
import mcTypes

private enum Target {
   case center, margins, bounds
   case vertically, horizontally
   case verticallyToMargins, horizontallyToMargins
   case horizontallyToSafeArea, verticallyToSafeArea, toSafeArea
   case insets(LayoutConstraint.EdgeInsets), horizontallyWithInsets(LayoutConstraint.EdgeInsets)
}

public class __LayoutConstraintHeight: InstanceHolder<LayoutConstraint> {

   public func to(_ constant: CGFloat, relation: LayoutConstraint.LayoutRelation = .equal,
                  multiplier: CGFloat = 1, _ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return views.map {
         NSLayoutConstraint(item: $0, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute,
                            multiplier: multiplier, constant: constant)
      }
   }
}

public class __LayoutConstraintSize: InstanceHolder<LayoutConstraint> {

   public func to(_ size: CGSize,
                  relationForHeight: LayoutConstraint.LayoutRelation = .equal,
                  relationForWidth: LayoutConstraint.LayoutRelation = .equal,
                  multiplierForHeight: CGFloat = 1, multiplierForWidth: CGFloat = 1,
                  _ view: LayoutConstraint.ViewType) -> [NSLayoutConstraint] {
      let constraintW = NSLayoutConstraint(item: view, attribute: .width, relatedBy: relationForWidth,
                                           toItem: nil, attribute: .notAnAttribute,
                                           multiplier: multiplierForWidth, constant: size.width)
      let constraintH = NSLayoutConstraint(item: view, attribute: .height, relatedBy: relationForHeight,
                                           toItem: nil, attribute: .notAnAttribute,
                                           multiplier: multiplierForHeight, constant: size.height)
      return [constraintH, constraintW]
   }

   public func toDimension(_ dimension: CGFloat, _ view: LayoutConstraint.ViewType) -> [NSLayoutConstraint] {
      return to(CGSize(dimension: dimension), view)
   }

   public func toMinimun(_ size: CGSize, _ view: LayoutConstraint.ViewType) -> [NSLayoutConstraint] {
      return to(size, relationForHeight: .greaterThanOrEqual, relationForWidth: .greaterThanOrEqual, view)
   }
}

public class __LayoutConstraintPin: InstanceHolder<LayoutConstraint> {

   public func toBounds(insets: LayoutConstraint.EdgeInsets, _ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .insets(insets), views)
   }

   public func toBounds(insets: CGFloat, _ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .insets(LayoutConstraint.EdgeInsets(dimension: insets)), views)
   }

   public func toBounds(_ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .bounds, views)
   }

   public func toBounds(in view: LayoutConstraint.ViewType, _ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(in: view, to: .bounds, views)
   }

   public func toMargins(_ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .margins, views)
   }

   public func horizontally(_ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .horizontally, views)
   }

   public func horizontally(in view: LayoutConstraint.ViewType, _ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(in: view, to: .horizontally, views)
   }

   public func horizontallyToMargins(_ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .horizontallyToMargins, views)
   }

   public func vertically(_ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .vertically, views)
   }

   public func verticallyToMargins(_ views: LayoutConstraint.ViewType...) -> [NSLayoutConstraint] {
      return instance.pin(to: .verticallyToMargins, views)
   }

   public func top(_ view: LayoutConstraint.ViewType, relatedBy: LayoutConstraint.LayoutRelation = .equal,
                   multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }
}

public class __LayoutConstraintCenter: InstanceHolder<LayoutConstraint> {

   public func xy(viewA: LayoutConstraint.ViewType, viewB: LayoutConstraint.ViewType, multiplierX: CGFloat = 1, constantX: CGFloat = 0,
                  multiplierY: CGFloat = 1, constantY: CGFloat = 0) -> [NSLayoutConstraint] {
      let constraintX = x(viewA: viewA, viewB: viewB, multiplier: multiplierX, constant: constantX)
      let constraintY = y(viewA: viewA, viewB: viewB, multiplier: multiplierY, constant: constantY)
      return [constraintX, constraintY]
   }

   public func xy(_ view: LayoutConstraint.ViewType, multiplierX: CGFloat = 1, constantX: CGFloat = 0,
                  multiplierY: CGFloat = 1, constantY: CGFloat = 0) -> [NSLayoutConstraint] {
      if let viewB = view.superview {
         return xy(viewA: view, viewB: viewB,
                   multiplierX: multiplierX, constantX: constantX, multiplierY: multiplierY, constantY: constantY)
      } else {
         return []
      }
   }

   public func y(viewA: LayoutConstraint.ViewType, viewB: LayoutConstraint.ViewType, multiplier: CGFloat = 1,
                 constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerY, relatedBy: .equal, toItem: viewB, attribute: .centerY,
                                multiplier: multiplier, constant: constant)
   }

   public func y(_ views: LayoutConstraint.ViewType..., multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      views.forEach {
         if let viewB = $0.superview {
            result.append(y(viewA: $0, viewB: viewB, multiplier: multiplier, constant: constant))
         }
      }
      return result
   }

   public func x(viewA: LayoutConstraint.ViewType, viewB: LayoutConstraint.ViewType, multiplier: CGFloat = 1,
                 constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .centerX,
                                multiplier: multiplier, constant: constant)
   }

   public func x(_ views: LayoutConstraint.ViewType..., multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      views.forEach {
         if let viewB = $0.superview {
            result.append(x(viewA: $0, viewB: viewB, multiplier: multiplier, constant: constant))
         }
      }
      return result
   }
}

public struct LayoutConstraint {

   public init() {}

   public var pin: __LayoutConstraintPin {
      return __LayoutConstraintPin(instance: self)
   }

   public var center: __LayoutConstraintCenter {
      return __LayoutConstraintCenter(instance: self)
   }

   public var size: __LayoutConstraintSize {
      return __LayoutConstraintSize(instance: self)
   }

   public var height: __LayoutConstraintHeight {
      return __LayoutConstraintHeight(instance: self)
   }

   public func bindings(_ bindings: [String: ViewType]) -> [String: ViewType] {
      return bindings
   }

   public func metrics(_ metrics: [String: CGFloat]) -> [String: Float] {
      return metrics.mapElements { ($0, Float($1)) }
   }

   #if os(iOS) || os(tvOS)
   public typealias LayoutRelation = NSLayoutConstraint.Relation
   public typealias ViewType = UIView
   public typealias LayoutFormatOptions = NSLayoutConstraint.FormatOptions
   public typealias EdgeInsets = UIEdgeInsets
   #elseif os(OSX)
   public typealias LayoutRelation = NSLayoutConstraint.Relation
   public typealias ViewType = NSView
   public typealias LayoutFormatOptions = NSLayoutConstraint.FormatOptions
   public typealias EdgeInsets = NSEdgeInsets
   #endif

   public enum Corner: Int {
      case bottomTrailing
      #if os(iOS) || os(tvOS)
      case bottomTrailingMargins
      #endif
   }

   public enum Border: Int {
      case leading, trailing, top, bottom
   }

   public enum Center {
      case both, vertically, horizontally
      case verticalOffset(CGFloat)
   }
}

extension LayoutConstraint {

   private func pinAtCenter(in container: ViewType, view: ViewType) -> [NSLayoutConstraint] {
      let result = [container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    view.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor),
                    view.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor)]
      return result
   }

   private func pin(in container: ViewType, to: Target, view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      switch to {
      case .center:
         result = pinAtCenter(in: container, view: view)
      case .insets(let insets):
         let metrics = ["top": insets.top, "bottom": insets.bottom, "left": insets.left, "right": insets.right]
         let metricsValue = metrics.mapElements { ($0, NSNumber(value: Float($1))) }
         var constraints: [NSLayoutConstraint] = []
         constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-(left)-[v]-(right)-|",
                                                       options: [], metrics: metricsValue, views: ["v": view])
         constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[v]-(bottom)-|",
                                                       options: [], metrics: metricsValue, views: ["v": view])
         result = constraints
      case .bounds:
         result += pin(in: container, to: .horizontally, view: view)
         result += pin(in: container, to: .vertically, view: view)
      case .margins:
         result += pin(in: container, to: .horizontallyToMargins, view: view)
         result += pin(in: container, to: .verticallyToMargins, view: view)
      case .horizontally:
         result += [view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    container.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
      case .vertically:
         result += [view.topAnchor.constraint(equalTo: container.topAnchor),
                    container.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
      case .horizontallyToMargins:
         result = NSLayoutConstraint.constraints(withVisualFormat: "|-[v]-|", options: [], metrics: nil, views: ["v": view])
      case .verticallyToMargins:
         result = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: nil, views: ["v": view])
      case .horizontallyToSafeArea:
         #if !os(macOS)
         result = [view.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
                   container.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
         #else
         fatalError()
         #endif
      case .verticallyToSafeArea:
         #if !os(macOS)
         result = [view.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
                   container.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
         #else
         fatalError()
         #endif
      case .toSafeArea:
         result = pin(in: container, to: .horizontallyToSafeArea, view: view)
            + pin(in: container, to: .verticallyToSafeArea, view: view)
      case .horizontallyWithInsets(let insets):
         result = NSLayoutConstraint.constraints(withVisualFormat: "|-\(insets.left)-[v]-\(insets.right)-|",
                                                 options: [], metrics: nil, views: ["v": view])
      }
      return result
   }

   private func pin(to: Target, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   fileprivate func pin(in view: ViewType, to: Target, _ views: [ViewType]) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   fileprivate func pin(to: Target, _ views: ViewType...) -> [NSLayoutConstraint] {
      return pin(to: to, views)
   }

   fileprivate func pin(to: Target, _ views: [ViewType]) -> [NSLayoutConstraint] {
      let result = views.map { pin(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private func pin(in container: ViewType, to: Border, view: ViewType) -> [NSLayoutConstraint] {
      let result: [NSLayoutConstraint]
      switch to {
      case .leading:
         result = pin(to: .vertically, view) + [pinLeadings(viewA: container, viewB: view)]
      case .trailing:
         result = pin(to: .vertically, view) + [pinTrailings(viewA: container, viewB: view)]
      case .top:
         result = pin(to: .horizontally, view) + [pinTops(viewA: container, viewB: view)]
      case .bottom:
         result = pin(to: .horizontally, view) + [pinBottoms(viewA: container, viewB: view)]
      }
      return result
   }

   private func pin(to: Border, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public func pin(in view: ViewType, to: Border, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public func pin(to: Border, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private func pin(in container: ViewType, at: Center, view: ViewType) -> [NSLayoutConstraint] {
      let result: [NSLayoutConstraint]
      switch at {
      case .both:
         result = pin(in: container, at: .vertically, view: view) + pin(in: container, at: .horizontally, view: view)
      case .vertically:
         result = [container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   view.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor)]
      case .horizontally:
         result = [container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                   view.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor)]
      case .verticalOffset(let offset):
         result = [container.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                   view.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: offset)]
      }
      return result
   }

   private func pin(at: Center, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, at: at, view: view)
      }
      return result
   }

   public func pin(in view: ViewType, at: Center, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, at: at, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public func pin(at: Center, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(at: at, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private func pin(in container: ViewType, to: Corner, view: ViewType) -> [NSLayoutConstraint] {
      let result: [NSLayoutConstraint]
      switch to {
      case .bottomTrailing:
         result = [container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   container.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
      #if os(iOS) || os(tvOS)
      case .bottomTrailingMargins:
         result = [container.layoutMarginsGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                   container.layoutMarginsGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor)]
      #endif
      }
      return result
   }

   private func pinInSuperView(to: Corner, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public func pin(in view: ViewType, to: Corner, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public func pinInSuperView(to: Corner, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pinInSuperView(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   public func withFormat(_ format: String, options: LayoutFormatOptions = [],
                          metrics: [String: Float] = [:], _ views: [ViewType]) -> [NSLayoutConstraint] {

      let parsedInfo = parseFormat(format: format, views: views)
      let metrics = metrics.mapValues { NSNumber(value: $0) }
      let result = NSLayoutConstraint.constraints(withVisualFormat: parsedInfo.0, options: options, metrics: metrics,
                                                  views: parsedInfo.1)
      return result
   }

   public func withFormat(_ format: String, options: LayoutFormatOptions = [],
                          metrics: [String: Float] = [:], _ views: ViewType...) -> [NSLayoutConstraint] {
      return withFormat(format, options: options, metrics: metrics, views)
   }

   public func withFormat(_ format: String, options: LayoutFormatOptions = [],
                          metrics: [String: Float] = [:], forEveryViewIn: ViewType...) -> [NSLayoutConstraint] {

      let result = forEveryViewIn.map { withFormat(format, options: options, metrics: metrics, $0) }.reduce([]) { $0 + $1 }
      return result
   }

   private func parseFormat(format: String, views: [ViewType]) -> (String, [String: Any]) {
      let viewPlaceholderCharacter = "*"
      var viewBindings: [String: Any] = [:]
      var parsedFormat = format
      for (index, view) in views.enumerated() {
         let viewBinding = "v\(index)"
         viewBindings[viewBinding] = view
         parsedFormat = parsedFormat.replacingFirstOccurrence(of: viewPlaceholderCharacter, with: viewBinding)
      }
      return (parsedFormat, viewBindings)
   }

   // MARK: - Dimensions

   public func constrainWidth(constant: CGFloat, relation: LayoutRelation = .equal,
                              multiplier: CGFloat = 1, _ views: ViewType...) -> [NSLayoutConstraint] {
      return views.map {
         NSLayoutConstraint(item: $0, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute,
                            multiplier: multiplier, constant: constant)
      }
   }

   public func equalWidth(viewA: ViewType, viewB: ViewType, relation: LayoutRelation = .equal,
                          multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .width, relatedBy: relation, toItem: viewB, attribute: .width,
                                multiplier: multiplier, constant: constant)
   }

   public func equalHeight(viewA: ViewType, viewB: ViewType, relation: LayoutRelation = .equal,
                           multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .height, relatedBy: relation, toItem: viewB, attribute: .height,
                                multiplier: multiplier, constant: constant)
   }

   public func equalHeight(_ views: [ViewType]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      var previousView: ViewType?
      for view in views {
         if let previousView = previousView {
            constraints.append(equalHeight(viewA: previousView, viewB: view))
         }
         previousView = view
      }
      return constraints
   }

   public func equalSize(viewA: ViewType, viewB: ViewType) -> [NSLayoutConstraint] {
      let cH = NSLayoutConstraint(item: viewA, attribute: .height, relatedBy: .equal,
                                  toItem: viewB, attribute: .height,
                                  multiplier: 1, constant: 0)

      let cW = NSLayoutConstraint(item: viewA, attribute: .width, relatedBy: .equal,
                                  toItem: viewB, attribute: .width,
                                  multiplier: 1, constant: 0)

      return [cH, cW]
   }

   public func constrainAspectRatio(view: ViewType, aspectRatio: CGFloat = 1) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height,
                                multiplier: aspectRatio, constant: 0)
   }

   // MARK: - Pinning

   public func pinLeading(_ view: ViewType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public func pinLeadings(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                           constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .leading, relatedBy: .equal, toItem: viewB, attribute: .leading,
                                multiplier: multiplier, constant: constant)
   }

   public func pinTrailings(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                            constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .trailing, relatedBy: .equal, toItem: viewB, attribute: .trailing,
                                multiplier: multiplier, constant: constant)
   }

   public func pinTrailing(_ view: ViewType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [pinTrailings(viewA: view, viewB: superview, multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public func pinCenterToLeading(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                  constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .leading,
                                multiplier: multiplier, constant: constant)
   }

   public func pinCenterToTrailing(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                   constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .trailing,
                                multiplier: multiplier, constant: constant)
   }

   public func pinTops(viewA: ViewType, viewB: ViewType, relatedBy: LayoutRelation = .equal,
                       multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .top,
                                multiplier: multiplier, constant: constant)
   }

   public func pinBottoms(viewA: ViewType, viewB: ViewType, relatedBy: LayoutRelation = .equal,
                          multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .bottom, relatedBy: .equal, toItem: viewB, attribute: .bottom,
                                multiplier: multiplier, constant: constant)
   }

   public func pinBottom(_ view: ViewType, relatedBy: LayoutRelation = .equal,
                         multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public func pinTopToBottom(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                              constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .bottom,
                                multiplier: multiplier, constant: constant)
   }

   public func pinBottomToTop(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                              constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .bottom, relatedBy: .equal, toItem: viewB, attribute: .top,
                                multiplier: multiplier, constant: constant)
   }

   #if os(iOS) || os(tvOS)
   public func pinToEdge(_ edge: UIRectEdge, view: ViewType) -> [NSLayoutConstraint] {
      if edge == .top {
         return withFormat("|[*]|", view) + withFormat("V:|[*]", view)
      } else if edge == .bottom {
         return withFormat("|[*]|", view) + withFormat("V:[*]|", view)
      } else if edge == .left {
         return withFormat("|[*]", view) + withFormat("V:|[*]|", view)
      } else if edge == .right {
         return withFormat("[*]|", view) + withFormat("V:|[*]|", view)
      } else {
         return []
      }
   }
   #endif
}

extension LayoutConstraint {

   public func distributeHorizontally(_ views: [ViewType], spacing: CGFloat) -> [NSLayoutConstraint] {
      let format = repeatElement("[*]", count: views.count).joined(separator: "-\(spacing)-")
      return withFormat(format, views)
   }

   public func alignCenterY(_ views: [ViewType]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      var previousView: ViewType?
      for view in views {
         if let previousView = previousView {
            constraints.append(center.y(viewA: previousView, viewB: view))
         }
         previousView = view
      }
      return constraints
   }
}

extension Array where Element: NSLayoutConstraint {

   public func activate(priority: LayoutPriority? = nil) {
      if let priority = priority {
         forEach { $0.priority = priority }
      }
      NSLayoutConstraint.activate(self)
   }

   /// I.e. `999` fix for Apple layout engine issues observed in Cells.
   public func activateApplyingNonRequiredLastItemPriotity() {
      last?.priority = .required - 1
      NSLayoutConstraint.activate(self)
   }

   public func deactivate() {
      NSLayoutConstraint.deactivate(self)
   }
}
