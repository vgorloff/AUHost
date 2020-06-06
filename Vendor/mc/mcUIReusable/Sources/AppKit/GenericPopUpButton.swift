//
//  GenericPopUpButton.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 25.02.19.
//  Copyright © 2019 Vlad Gorlov. All rights reserved.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

open class GenericPopUpButton<T: Any & Equatable>: PopUpButton {

   public var onSelected: ((T) -> Void)?

   public init() {
      super.init()
      setHandler { [weak self] in
         self?.handleSelected()
      }
   }

   public required init?(coder: NSCoder) {
      fatalError()
   }

   public var selectedElement: T? {
      get {
         return selectedItem?.representedObject as? T
      } set {
         var item: NSMenuItem?
         if let value = newValue {
            item = itemArray.first(where: { ($0.representedObject as? T) == value })
         }
         select(item)
      }
   }

   // MARK: -

   private func handleSelected() {
      if let value = selectedItem?.representedObject as? T {
         onSelected?(value)
      }
   }
}
#endif
