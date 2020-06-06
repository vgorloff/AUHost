//
//  UISegmentedControl.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 06.06.2020.
//  Copyright © 2020 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import UIKit

extension UISegmentedControl {

   public func setBackgroundImage(_ backgroundImage: UIImage?, for states: UIControl.State..., barMetrics: UIBarMetrics) {
      for state in states {
         setBackgroundImage(backgroundImage, for: state, barMetrics: barMetrics)
      }
   }

   public func setBackgroundImage(_ backgroundImage: UIImage?, for states: [UIControl.State], barMetrics: UIBarMetrics = .default) {
      for state in states {
         setBackgroundImage(backgroundImage, for: state, barMetrics: barMetrics)
      }
   }

   public func setDividerImage(_ image: UIImage?, for states: [UIControl.State], barMetrics: UIBarMetrics = .default) {
      for leftState in states {
         for rightState in states {
            setDividerImage(image, forLeftSegmentState: leftState, rightSegmentState: rightState, barMetrics: barMetrics)
         }
      }
   }

   func setAllBackgroundImagesToNil(barMetrics: UIBarMetrics = .default) {
      setBackgroundImage(nil, for: .normal, barMetrics: barMetrics)
      setBackgroundImage(nil, for: .highlighted, barMetrics: barMetrics)
      setBackgroundImage(nil, for: .selected, barMetrics: barMetrics)
      setBackgroundImage(nil, for: .disabled, barMetrics: barMetrics)
      if #available(iOS 9.0, *) {
         setBackgroundImage(nil, for: .focused, barMetrics: barMetrics)
      }
   }

   public func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?, for states: [UIControl.State]) {
      for state in states {
         setTitleTextAttributes(attributes, for: state)
      }
   }

   func setAllDividerImagesToNil(barMetrics: UIBarMetrics = .default) {
      setDividerImage(nil, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: barMetrics)
      setDividerImage(nil, forLeftSegmentState: .normal, rightSegmentState: .selected, barMetrics: barMetrics)
      setDividerImage(nil, forLeftSegmentState: .selected, rightSegmentState: .selected, barMetrics: barMetrics)
   }

   public func setSelectedSegmentIndexChangedHandler(_ handler: ((Int) -> Void)?) {
      super.setValueChangedHandler { [weak self] in guard let s = self else { return }
         handler?(s.selectedSegmentIndex)
      }
   }
}
#endif
