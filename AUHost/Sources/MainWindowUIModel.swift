//
//  MainWindowModel.swift
//  AUHost
//
//  Created by VG (DE) on 17.06.17.
//  Copyright © 2017 WaveLabs. All rights reserved.
//

import Foundation

protocol MainWindowUIModelType: class {
   func toggleMediaBrowser(sender: Any?)
   func reloadEffects()
}

class MainWindowUIModel {

   enum CoordinatorEvent {
      case reloadEffects
      case toggleMediaBrowser(sender: Any?)
   }

   var coordinatorHandler: ((CoordinatorEvent) -> Void)?
}

extension MainWindowUIModel: MainWindowUIModelType {

   func toggleMediaBrowser(sender: Any?) {
      coordinatorHandler?(.toggleMediaBrowser(sender: sender))
   }

   func reloadEffects() {
      coordinatorHandler?(.reloadEffects)
   }
}
