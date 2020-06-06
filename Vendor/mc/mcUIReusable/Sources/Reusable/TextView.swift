//
//  TextView.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcFoundationObservables
import mcUI
import UIKit

open class TextView: UITextView {

   public var onTextDidChange: ((String) -> Void)?

   private var placeholderView: UIView?
   private var placeholderInsets = UIEdgeInsets()
   private var userDefinedIntrinsicContentSize: CGSize?
   private var observers: [NotificationObserver] = []

   override public init(frame: CGRect, textContainer: NSTextContainer?) {
      var adjustedFrame = frame
      if frame.size.width < CGFloat.leastNormalMagnitude {
         adjustedFrame.size.width = CGFloat.leastNormalMagnitude
      }
      if frame.size.height < CGFloat.leastNormalMagnitude {
         adjustedFrame.size.height = CGFloat.leastNormalMagnitude
      }
      super.init(frame: frame, textContainer: textContainer)
      setupNotifications()

      setupUI()
      setupLayout()
      setupHandlers()
      setupDefaults()
   }

   public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
   }

   @objc open dynamic func setupUI() {
      // Base class does nothing.
   }

   @objc open dynamic func setupLayout() {
      // Base class does nothing.
   }

   @objc open dynamic func setupHandlers() {
      // Base class does nothing.
   }

   @objc open dynamic func setupDefaults() {
      // Base class does nothing.
   }

   override open var intrinsicContentSize: CGSize {
      return userDefinedIntrinsicContentSize ?? super.intrinsicContentSize
   }

   override open func layoutSubviews() {
      super.layoutSubviews()
      updatePlaceholder()
   }
}

extension TextView {

   /// When passed **nil**, then system value is used.
   public func setIntrinsicContentSize(_ size: CGSize?) {
      userDefinedIntrinsicContentSize = size
   }

   public func setPlaceholderView(_ view: UIView, insets: UIEdgeInsets = UIEdgeInsets()) {
      placeholderView?.removeFromSuperview()
      placeholderView = view
      view.translatesAutoresizingMaskIntoConstraints = true
      view.isUserInteractionEnabled = false
      placeholderInsets = insets
      addSubview(view)
      view.isHidden = !text.isEmpty
      updatePlaceholder()
   }

   private func updatePlaceholder() {
      if let placeholderView = placeholderView {
         let width = bounds.width - placeholderInsets.horizontal
         let size = placeholderView.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
         let frame = CGRect(x: placeholderInsets.left, y: placeholderInsets.top,
                            width: width, height: min(size.height, bounds.height - placeholderInsets.vertical))
         placeholderView.frame = frame
      }
   }

   private func setupNotifications() {
      observers.append(NotificationObserver(name: UITextView.textDidChangeNotification, object: self, queue: .main) { [weak self] _ in
         if let this = self {
            self?.placeholderView?.isHidden = !this.text.isEmpty
            self?.onTextDidChange?(this.text)
         }
      })
   }
}

#endif
