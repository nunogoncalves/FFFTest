//
//  FlickrPhotoTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class FlickrPhotoTests: XCTestCase {
    
    let json: JSON = [
        "id" : "123",
        "farm" : 456,
        "server" : "serverValue",
        "secret" : "secretValue"
    ]
    
    var flickrPhoto: FlickrPhoto?
    
    func testPhotoBuit() {
        flickrPhoto = FlickrPhoto(json: json)
        XCTAssertTrue(flickrPhoto != nil)
    }
    
    func testPhotoNotBuiltWithEmptyJSON() {
        flickrPhoto = FlickrPhoto(json: [:])
        XCTAssertTrue(flickrPhoto == nil)
    }
    
    func testPhotoNotBuiltWithWrongJSON() {
        let badJSON : JSON = [
            "-id" : "123",
            "farm" : 456,
            "server" : "serverValue",
            "secret" : "secretValue"
        ]
        flickrPhoto = FlickrPhoto(json: badJSON)
        XCTAssertTrue(flickrPhoto == nil)
    }
    
    func testPhotoProperties() {
        flickrPhoto = FlickrPhoto(json: json)
        let idExpectation = "123"
        let idResult = flickrPhoto!.id
        let secretExpectation = "secretValue"
        let secretResult = flickrPhoto!.secret
        XCTAssertTrue(idResult == idExpectation)
        XCTAssertTrue(secretExpectation == secretResult)
    }

    func testCorrectUrl() {
        flickrPhoto = FlickrPhoto(json: json)
        let size = FlickrImageSize.largeLongerSide1024
        let urlExpectation = URL(string: "https://farm456.staticflickr.com/serverValue/123_secretValue_\(size.rawValue).jpg")!
        let urlResult = flickrPhoto!.url(for: .largeLongerSide1024)
        XCTAssertTrue(urlExpectation == urlResult, "Expected \(urlExpectation), got \(urlResult)")
    }
}
