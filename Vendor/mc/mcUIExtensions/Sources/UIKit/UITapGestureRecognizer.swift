//
//  UITapGestureRecognizer.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UITapGestureRecognizer {

   public convenience init(numberOfTapsRequired: Int, handler: UIGestureRecognizer.Handler?) {
      self.init(handler: handler)
      self.numberOfTapsRequired = numberOfTapsRequired
   }

   public func isTapOnAttributedTextForLabelInRange(label: UILabel, inRange targetRange: NSRange) -> Bool {

      guard let attributedText = label.attributedText else {
         return false
      }

      // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
      let layoutManager = NSLayoutManager()
      let textContainer = NSTextContainer(size: CGSize.zero)
      let textStorage = NSTextStorage(attributedString: attributedText)

      // Configure layoutManager and textStorage
      layoutManager.addTextContainer(textContainer)
      textStorage.addLayoutManager(layoutManager)

      // Configure textContainer
      textContainer.lineFragmentPadding = 0
      textContainer.lineBreakMode = label.lineBreakMode
      textContainer.maximumNumberOfLines = label.numberOfLines
      let labelSize = label.bounds.size
      textContainer.size = labelSize

      // Find the tapped character location and compare it to the specified range
      let locationOfTouchInLabel = location(in: label)
      let textBoundingBox = layoutManager.usedRect(for: textContainer)
      let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                        y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
      let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x,
                                                   y: locationOfTouchInLabel.y - textContainerOffset.y)
      let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer,
                                                          in: textContainer,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)

      return NSLocationInRange(indexOfCharacter, targetRange)
   }
}
#endif
