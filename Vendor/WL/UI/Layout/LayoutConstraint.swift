//
//  LayoutConstraint.swift
//  WLUI
//
//  Created by Vlad Gorlov on 04/05/16.
//  Copyright © 2016 WaveLabs. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public struct LayoutConstraint {

   public static func bindings(_ bindings: [String: ViewType]) -> [String: ViewType] {
      return bindings
   }

   public static func metrics(_ metrics: [String: CGFloat]) -> [String: Float] {
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

   public enum Target {
      case margins, bounds, insets(EdgeInsets)
      case horizontal(CGFloat, CGFloat)
      case vertically, horizontally
      case verticallyToMargins, horizontallyToMargins
   }

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

   private static func pinWithInsets(_ insets: EdgeInsets, in container: ViewType, view: ViewType) -> [NSLayoutConstraint] {
      let metrics = ["top": insets.top, "bottom": insets.bottom, "left": insets.left, "right": insets.right]
      let metricsValue = metrics.mapElements { ($0, NSNumber(value: Float($1))) }
      var constraints: [NSLayoutConstraint] = []
      constraints += NSLayoutConstraint.constraints(withVisualFormat: "|-(left)-[v]-(right)-|",
                                                    options: [], metrics: metricsValue, views: ["v": view])
      constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(top)-[v]-(bottom)-|",
                                                    options: [], metrics: metricsValue, views: ["v": view])
      return constraints
   }

   private static func pin(in container: ViewType, to: Target, view: ViewType) -> [NSLayoutConstraint] {
      let result: [NSLayoutConstraint]
      switch to {
      case .insets(let insets):
         result = pinWithInsets(insets, in: container, view: view)
      case .bounds:
         result = pin(in: container, to: .horizontally, view: view) + pin(in: container, to: .vertically, view: view)
      case .margins:
         result =
            pin(in: container, to: .horizontallyToMargins, view: view) + pin(in: container, to: .verticallyToMargins, view: view)
      case .horizontally:
         result = NSLayoutConstraint.constraints(withVisualFormat: "|[v]|", options: [], metrics: nil, views: ["v": view])
      case .vertically:
         result = NSLayoutConstraint.constraints(withVisualFormat: "V:|[v]|", options: [], metrics: nil, views: ["v": view])
      case .horizontallyToMargins:
         result = NSLayoutConstraint.constraints(withVisualFormat: "|-[v]-|", options: [], metrics: nil, views: ["v": view])
      case .verticallyToMargins:
         result = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: nil, views: ["v": view])
      case .horizontal(let leading, let trailing):
         result = NSLayoutConstraint.constraints(withVisualFormat: "|-\(leading)-[v]-\(trailing)-|",
                                                 options: [], metrics: nil, views: ["v": view])
      }
      return result
   }

   private static func pin(to: Target, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public static func pin(in view: ViewType, to: Target, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public static func pin(to: Target, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private static func pin(in container: ViewType, to: Border, view: ViewType) -> [NSLayoutConstraint] {
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

   private static func pin(to: Border, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public static func pin(in view: ViewType, to: Border, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public static func pin(to: Border, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private static func pin(in container: ViewType, at: Center, view: ViewType) -> [NSLayoutConstraint] {
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

   private static func pin(at: Center, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, at: at, view: view)
      }
      return result
   }

   public static func pin(in view: ViewType, at: Center, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, at: at, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public static func pin(at: Center, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(at: at, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

extension LayoutConstraint {

   private static func pin(in container: ViewType, to: Corner, view: ViewType) -> [NSLayoutConstraint] {
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

   private static func pin(to: Corner, _ view: ViewType) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      if let superview = view.superview {
         result = pin(in: superview, to: to, view: view)
      }
      return result
   }

   public static func pin(in view: ViewType, to: Corner, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(in: view, to: to, view: $0) }.reduce([]) { $0 + $1 }
      return result
   }

   public static func pin(to: Corner, _ views: ViewType...) -> [NSLayoutConstraint] {
      let result = views.map { pin(to: to, $0) }.reduce([]) { $0 + $1 }
      return result
   }
}

#if os(iOS) || os(tvOS)

extension LayoutConstraint {

   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], toSafeAreasOrLayoutGudesOf viewController: UIViewController,
                                 _ views: ViewType...) -> [NSLayoutConstraint] {
      if #available(iOS 11.0, tvOS 11.0, *) {
         return withFormat(format, options: options, metrics: metrics, toSafeAreasOf: viewController.view, views)
      } else {
         return withFormat(format, options: options, metrics: metrics, viewController: viewController, views)
      }
   }

   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], viewController: UIViewController,
                                 _ views: ViewType...) -> [NSLayoutConstraint] {
      return withFormat(format, options: options, metrics: metrics, viewController: viewController, views)
   }

   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], viewController: UIViewController,
                                 _ views: [ViewType]) -> [NSLayoutConstraint] {

      let parsedInfo = parseFormat(format: format, views: views)
      var parsedFormat = parsedInfo.0
      var bindings = parsedInfo.1
      let topAnchorSymbol = "topLayoutGuide"
      let bottomAnchorSymbol = "bottomLayoutGuide"
      if parsedFormat.hasPrefix("V:|") {
         parsedFormat = parsedFormat.replacingFirstOccurrence(of: "|", with: "[\(topAnchorSymbol)]")
         bindings[topAnchorSymbol] = viewController.topLayoutGuide

         if parsedFormat.hasSuffix("|") {
            parsedFormat = parsedFormat.replacingLastOccurrence(of: "|", with: "[\(bottomAnchorSymbol)]")
            bindings[bottomAnchorSymbol] = viewController.bottomLayoutGuide
         }
      }

      let metrics = metrics.mapValues { NSNumber(value: $0) }
      return NSLayoutConstraint.constraints(withVisualFormat: parsedFormat, options: options, metrics: metrics, views: bindings)
   }

   @available(iOS 11.0, tvOS 11.0, *)
   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], toSafeAreasOf targetView: ViewType,
                                 _ views: ViewType...) -> [NSLayoutConstraint] {
      return withFormat(format, options: options, metrics: metrics, toSafeAreasOf: targetView, views)
   }

   @available(iOS 11.0, tvOS 11.0, *)
   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], toSafeAreasOf targetView: ViewType,
                                 _ views: [ViewType]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      let parsedInfo = parseFormat(format: format, views: views)
      let safeAreaLayoutGuide = targetView.safeAreaLayoutGuide
      var parsedFormat = parsedInfo.0
      if parsedFormat.hasPrefix("H:|") {
         parsedFormat = parsedFormat.replacingFirstOccurrence(of: "H:|", with: "|")
      }
      if parsedFormat.hasPrefix("V:|") {
         if let view = views.first {
            if let result = LayoutFormatParser(format: parsedFormat).parseTop() {
               constraints.append(view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: result.dimension))
               parsedFormat = result.format
            } else {
               constraints.append(view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor))
               parsedFormat = parsedFormat.replacingFirstOccurrence(of: "|", with: "")
            }
         }
         if parsedFormat.hasSuffix("|") {
            if let view = views.last {
               if let result = LayoutFormatParser(format: parsedFormat).parseBottom() {
                  constraints.append(safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                                 constant: result.dimension))
                  parsedFormat = result.format
               } else {
                  constraints.append(safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor))
                  parsedFormat = parsedFormat.replacingLastOccurrence(of: "|", with: "")
               }
            }
         }
      } else if parsedFormat.hasPrefix("|") {
         if let view = views.first {
            if let result = LayoutFormatParser(format: parsedFormat).parseLeading() {
               constraints.append(view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                                constant: result.dimension))
               parsedFormat = result.format
            } else {
               constraints.append(view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor))
               parsedFormat = parsedFormat.replacingFirstOccurrence(of: "|", with: "")
            }
         }
         if parsedFormat.hasSuffix("|") {
            if let view = views.last {
               if let result = LayoutFormatParser(format: parsedFormat).parseTrailing() {
                  constraints.append(safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                                                   constant: result.dimension))
                  parsedFormat = result.format
               } else {
                  constraints.append(safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor))
                  parsedFormat = parsedFormat.replacingLastOccurrence(of: "|", with: "")
               }
            }
         }
      }

      let metrics = metrics.mapValues { NSNumber(value: $0) }
      constraints += NSLayoutConstraint.constraints(withVisualFormat: parsedFormat, options: options,
                                                    metrics: metrics, views: parsedInfo.1)
      return constraints
   }
}

#endif

extension LayoutConstraint {

   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], _ views: [ViewType]) -> [NSLayoutConstraint] {

      let parsedInfo = parseFormat(format: format, views: views)
      let metrics = metrics.mapValues { NSNumber(value: $0) }
      let result = NSLayoutConstraint.constraints(withVisualFormat: parsedInfo.0, options: options, metrics: metrics,
                                                  views: parsedInfo.1)
      return result
   }

   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], _ views: ViewType...) -> [NSLayoutConstraint] {
      return withFormat(format, options: options, metrics: metrics, views)
   }

   public static func withFormat(_ format: String, options: LayoutFormatOptions = [],
                                 metrics: [String: Float] = [:], forEveryViewIn: ViewType...) -> [NSLayoutConstraint] {

      let result = forEveryViewIn.map { withFormat(format, options: options, metrics: metrics, $0) }.reduce([]) { $0 + $1 }
      return result
   }

   private static func parseFormat(format: String, views: [ViewType]) -> (String, [String: Any]) {
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

   // MARK: - Centering

   public static func centerY(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                              constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerY, relatedBy: .equal, toItem: viewB, attribute: .centerY,
                                multiplier: multiplier, constant: constant)
   }

   public static func centerY(_ views: ViewType..., multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      views.forEach {
         if let viewB = $0.superview {
            result.append(centerY(viewA: $0, viewB: viewB, multiplier: multiplier, constant: constant))
         }
      }
      return result
   }

   public static func centerX(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                              constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .centerX,
                                multiplier: multiplier, constant: constant)
   }

   public static func centerX(_ views: ViewType..., multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      var result: [NSLayoutConstraint] = []
      views.forEach {
         if let viewB = $0.superview {
            result.append(centerX(viewA: $0, viewB: viewB, multiplier: multiplier, constant: constant))
         }
      }
      return result
   }

   public static func centerXY(viewA: ViewType, viewB: ViewType, multiplierX: CGFloat = 1, constantX: CGFloat = 0,
                               multiplierY: CGFloat = 1, constantY: CGFloat = 0) -> [NSLayoutConstraint] {
      let constraintX = LayoutConstraint.centerX(viewA: viewA, viewB: viewB, multiplier: multiplierX, constant: constantX)
      let constraintY = LayoutConstraint.centerY(viewA: viewA, viewB: viewB, multiplier: multiplierY, constant: constantY)
      return [constraintX, constraintY]
   }

   public static func centerXY(_ view: ViewType, multiplierX: CGFloat = 1, constantX: CGFloat = 0,
                               multiplierY: CGFloat = 1, constantY: CGFloat = 0) -> [NSLayoutConstraint] {
      if let viewB = view.superview {
         return centerXY(viewA: view, viewB: viewB,
                         multiplierX: multiplierX, constantX: constantX, multiplierY: multiplierY, constantY: constantY)
      } else {
         return []
      }
   }

   // MARK: - Dimensions

   public static func constrainHeight(constant: CGFloat, relation: LayoutRelation = .equal,
                                      multiplier: CGFloat = 1, _ views: ViewType...) -> [NSLayoutConstraint] {
      return views.map {
         NSLayoutConstraint(item: $0, attribute: .height, relatedBy: relation, toItem: nil, attribute: .notAnAttribute,
                            multiplier: multiplier, constant: constant)
      }
   }

   public static func constrainWidth(constant: CGFloat, relation: LayoutRelation = .equal,
                                     multiplier: CGFloat = 1, _ views: ViewType...) -> [NSLayoutConstraint] {
      return views.map {
         NSLayoutConstraint(item: $0, attribute: .width, relatedBy: relation, toItem: nil, attribute: .notAnAttribute,
                            multiplier: multiplier, constant: constant)
      }
   }

   public static func constrainSize(view: ViewType,
                                    relationForHeight: LayoutRelation = .equal,
                                    relationForWidth: LayoutRelation = .equal,
                                    multiplierForHeight: CGFloat = 1, multiplierForWidth: CGFloat = 1,
                                    size: CGSize) -> [NSLayoutConstraint] {
      let constraintW = NSLayoutConstraint(item: view, attribute: .width, relatedBy: relationForWidth,
                                           toItem: nil, attribute: .notAnAttribute,
                                           multiplier: multiplierForWidth, constant: size.width)
      let constraintH = NSLayoutConstraint(item: view, attribute: .height, relatedBy: relationForHeight,
                                           toItem: nil, attribute: .notAnAttribute,
                                           multiplier: multiplierForHeight, constant: size.height)
      return [constraintH, constraintW]
   }

   public static func minimunSize(view: ViewType, size: CGSize) -> [NSLayoutConstraint] {
      return constrainSize(view: view, relationForHeight: .greaterThanOrEqual, relationForWidth: .greaterThanOrEqual, size: size)
   }

   public static func equalWidth(viewA: ViewType, viewB: ViewType, relation: LayoutRelation = .equal,
                                 multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .width, relatedBy: relation, toItem: viewB, attribute: .width,
                                multiplier: multiplier, constant: constant)
   }

   public static func equalHeight(viewA: ViewType, viewB: ViewType, relation: LayoutRelation = .equal,
                                  multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .height, relatedBy: relation, toItem: viewB, attribute: .height,
                                multiplier: multiplier, constant: constant)
   }

   public static func equalSize(viewA: ViewType, viewB: ViewType) -> [NSLayoutConstraint] {
      let cH = NSLayoutConstraint(item: viewA, attribute: .height, relatedBy: .equal,
                                  toItem: viewB, attribute: .height,
                                  multiplier: 1, constant: 0)

      let cW = NSLayoutConstraint(item: viewA, attribute: .width, relatedBy: .equal,
                                  toItem: viewB, attribute: .width,
                                  multiplier: 1, constant: 0)

      return [cH, cW]
   }

   public static func constrainAspectRatio(view: ViewType, aspectRatio: CGFloat = 1) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: view, attribute: .height,
                                multiplier: aspectRatio, constant: 0)
   }

   // MARK: - Pinning

   public static func pinLeading(_ view: ViewType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinLeadings(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                  constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .leading, relatedBy: .equal, toItem: viewB, attribute: .leading,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTrailings(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                   constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .trailing, relatedBy: .equal, toItem: viewB, attribute: .trailing,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTrailing(_ view: ViewType, multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinCenterToLeading(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                         constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .leading,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinCenterToTrailing(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                          constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .centerX, relatedBy: .equal, toItem: viewB, attribute: .trailing,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTops(viewA: ViewType, viewB: ViewType, relatedBy: LayoutRelation = .equal,
                              multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .top,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinTop(_ view: ViewType, relatedBy: LayoutRelation = .equal,
                             multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinBottoms(viewA: ViewType, viewB: ViewType, relatedBy: LayoutRelation = .equal,
                                 multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .bottom, relatedBy: .equal, toItem: viewB, attribute: .bottom,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinBottom(_ view: ViewType, relatedBy: LayoutRelation = .equal,
                                multiplier: CGFloat = 1, constant: CGFloat = 0) -> [NSLayoutConstraint] {
      if let superview = view.superview {
         return [NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom,
                                    multiplier: multiplier, constant: constant)]
      } else {
         return []
      }
   }

   public static func pinTopToBottom(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                     constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .top, relatedBy: .equal, toItem: viewB, attribute: .bottom,
                                multiplier: multiplier, constant: constant)
   }

   public static func pinBottomToTop(viewA: ViewType, viewB: ViewType, multiplier: CGFloat = 1,
                                     constant: CGFloat = 0) -> NSLayoutConstraint {
      return NSLayoutConstraint(item: viewA, attribute: .bottom, relatedBy: .equal, toItem: viewB, attribute: .top,
                                multiplier: multiplier, constant: constant)
   }

   #if os(iOS) || os(tvOS)
   public static func pinToEdge(_ edge: UIRectEdge, view: ViewType) -> [NSLayoutConstraint] {
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

   public static func distributeHorizontally(_ views: [ViewType], spacing: CGFloat) -> [NSLayoutConstraint] {
      let format = repeatElement("[*]", count: views.count).joined(separator: "-\(spacing)-")
      return LayoutConstraint.withFormat(format, views)
   }

   public static func alignCenterY(_ views: [ViewType]) -> [NSLayoutConstraint] {
      var constraints: [NSLayoutConstraint] = []
      var previousView: ViewType?
      for view in views {
         if let previousView = previousView {
            constraints.append(LayoutConstraint.centerY(viewA: previousView, viewB: view))
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
