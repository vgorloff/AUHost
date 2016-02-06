//
//  AudioUnitsDatasourceTests.swift
//  WLMedia
//
//  Created by User on 6/25/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import XCTest
import AUExKit

class AudioUnitsDatasourceTests: GenericTestCase {

  func testUpdateEffectList() {
    let auds = AudioUnitsDatasource()
    XCTAssertTrue(auds.availableEffects.count == 0)
    let x = expectationWithDescription("Update Effects list")
    auds.updateEffectList { effects in
      XCTAssertTrue(effects.count > 0)
      x.fulfill()
    }
    waitForExpectationsWithTimeout(180, handler: nil)
  }

}
