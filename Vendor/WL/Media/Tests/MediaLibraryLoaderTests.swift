//
//  MediaLibraryLoaderTests.swift
//  WLMedia
//
//  Created by User on 6/24/15.
//  Copyright © 2015 WaveLabs. All rights reserved.
//

import XCTest
import AUExKit

class MediaLibraryLoaderTests: GenericTestCase {

  func testInitAndDestroy() {
    let l = MediaLibraryLoader()
    XCTAssertNotNil(l)
  }

  func testLoadMediaLibrary() {
    let l = MediaLibraryLoader()
    let x = expectationWithDescription("Library loaded")
		l.loadMediaLibrary { sources in
			XCTAssertNotNil(sources)
			XCTAssertTrue(sources?.count > 0)
			x.fulfill()
		}
    waitForExpectationsWithTimeout(180, handler: nil)
  }

}
