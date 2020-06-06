//
//  ReusableCollectionViewCell.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 07.08.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcUI
import UIKit

public class ReusableCollectionViewCell<T: UIView>: UICollectionViewCell {

   public let view: T

   override public init(frame: CGRect) {
      view = T().autolayoutView()
      super.init(frame: frame)
      setPinnedToMargins(false)
   }

   fileprivate func setPinnedToMargins(_ value: Bool) {
      view.removeFromSuperview()
      contentView.addSubview(view)
      if value {
         anchor.withFormat("|-[*]-|", view).activate()
         anchor.withFormat("V:|-[*]-|", view).activate()
      } else {
         anchor.withFormat("|[*]|", view).activate()
         anchor.withFormat("V:|[*]|", view).activate()
      }
   }

   public required init?(coder aDecoder: NSCoder) {
      fatalError()
   }

   override public func prepareForReuse() {
      super.prepareForReuse()
      if let view = view as? ReusableCellContentView {
         view.prepareForReuse()
      }
   }
}

extension UICollectionView {

   public func dequeueReusableViewCell<T: UIView>(_ viewType: T.Type, pinToMargins: Bool = false,
                                                  for indexPath: IndexPath) -> ReusableCollectionViewCell<T> {
      let cell = dequeueReusableCell(ReusableCollectionViewCell<T>.self, indexPath: indexPath)
      cell.setPinnedToMargins(pinToMargins)
      return cell
   }
}
#endif
