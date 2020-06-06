//
//  AlertController.swift
//  WaveLabs
//
//  Created by Vlad Gorlov on 03.06.18.
//  Copyright © 2018 Vlad Gorlov. All rights reserved.
//

#if canImport(UIKit)
import mcFoundation
import mcFoundationObservables
import mcTypes
import mcUIExtensions
import UIKit

public class AlertController: UIAlertController {

   public static let reportIssueNotification = Notification.Name(rawValue: "con.mc.reportIssue")

   private var screenshotImage: UIImage?
   private var shouldTakeScreenshot = false

   override public func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      if shouldTakeScreenshot {
         screenshotImage = UIApplication.shared.takeMainWindowScreenshot()
      }
   }

   public convenience init(alertWithError error: Swift.Error, cancelActionTitle: String) {
      if let printable = error as? PrintableError {
         self.init(alertWithTitle: printable.localizedTitle, message: printable.localizedDescription)
      } else {
         self.init(alertWithMessage: String(describing: error))
      }
      log.error(.controller, error)
      addCancelAction(cancelActionTitle)
   }

   public convenience init(alertWithError error: Swift.Error, cancelActionTitle: String,
                           defaultActionTitle: String, completion: @escaping () -> Void) {
      self.init(alertWithError: error, cancelActionTitle: cancelActionTitle)
      addDefaultAction(defaultActionTitle) { _ in
         completion()
      }
   }

   public convenience init(alertWithError error: Swift.Error, cancelActionTitle: String, screenshotReportingActionTitle: String) {
      self.init(alertWithError: error, cancelActionTitle: cancelActionTitle)
      shouldTakeScreenshot = true
      addDefaultAction(screenshotReportingActionTitle) { [weak self] _ in
         if let image = self?.screenshotImage {
            GenericNotification(name: AlertController.reportIssueNotification, payload: image).post()
         }
      }
   }

   public convenience init(alertWithMessage message: String, defaultActionTitle: String) {
      self.init(alertWithMessage: message)
      addDefaultAction(defaultActionTitle)
   }
}

#endif
