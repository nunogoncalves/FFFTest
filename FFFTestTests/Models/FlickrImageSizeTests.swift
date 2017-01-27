//
//  FlickrImageSizeTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class FlickrImageSizeTests: XCTestCase {
    
    func testImageSizesRawValues() {
        XCTAssertTrue(FlickrImageSize.smallSquare75.rawValue == "s")
        XCTAssertTrue(FlickrImageSize.largeSquare150.rawValue == "q")
        XCTAssertTrue(FlickrImageSize.minuatureLongerSide100.rawValue == "t")
        XCTAssertTrue(FlickrImageSize.smallLongerSide240.rawValue == "m")
        XCTAssertTrue(FlickrImageSize.largeLongerSide320.rawValue == "n")
        XCTAssertTrue(FlickrImageSize.mediumLongerSide500.rawValue == "-")
        XCTAssertTrue(FlickrImageSize.mediumLongerSide640.rawValue == "z")
        XCTAssertTrue(FlickrImageSize.mediumLongerSide800.rawValue == "c")
        XCTAssertTrue(FlickrImageSize.largeLongerSide1600.rawValue == "h")
        XCTAssertTrue(FlickrImageSize.largeLongerSide1024.rawValue == "b")
        XCTAssertTrue(FlickrImageSize.largeLongerSide2048.rawValue == "k")
        XCTAssertTrue(FlickrImageSize.original.rawValue == "o")
    }
}
