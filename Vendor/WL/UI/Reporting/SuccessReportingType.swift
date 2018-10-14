//
//  SuccessReportingType.swift
//  Carmudi
//
//  Created by VG (DE) on 19/12/2016.
//  Copyright © 2016 Carmudi GmbH. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public protocol SuccessReportingType {
   func reportSuccess(message: String)
}
