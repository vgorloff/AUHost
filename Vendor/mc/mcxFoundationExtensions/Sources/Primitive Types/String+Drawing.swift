//
//  String+Drawing.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if !os(macOS)
import Foundation
import UIKit

extension String {

   public func estimatedFrame(font: UIFont, width: CGFloat) -> CGRect {
      let size = CGSize(width: width, height: CGFloat(Int.max))
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options,
                                                               attributes: [NSAttributedString.Key.font: font], context: nil)
      return estimatedFrame
   }

   public func estimatedFrame(font: UIFont, width: CGFloat, height: CGFloat) -> CGRect {
      let size = CGSize(width: width, height: height)
      let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
      let estimatedFrame = NSString(string: self).boundingRect(with: size, options: options,
                                                               attributes: [NSAttributedString.Key.font: font], context: nil)
      return estimatedFrame
   }
}
#endif
