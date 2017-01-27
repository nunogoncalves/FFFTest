//
//  FlickrPhotoDetailsTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//


import XCTest
@testable import FFFTest

class FlickrPhotoDetailsTests: XCTestCase {
    
    let json: JSON = [
        "title" : ["_content" : "title of this photo"],
        "description" : ["_content" :"description of this photo"],
    ]
    
    var flickrPhotoDetails: FlickrPhotoDetails?
    
    func testPhotoBuit() {
       flickrPhotoDetails = FlickrPhotoDetails(json: json)
        XCTAssertTrue(flickrPhotoDetails != nil)
    }
    
    func testPhotoNotBuiltWithEmptyJSON() {
        flickrPhotoDetails = FlickrPhotoDetails(json: [:])
        XCTAssertTrue(flickrPhotoDetails == nil)
    }
    
    func testPhotoNotBuiltWithWrongJSON() {
        let badJSON : JSON = [
            "title" : ["xx_content" : "title of this photo"],
            "description" : ["xx_content" :"description of this photo"],
        ]
        flickrPhotoDetails = FlickrPhotoDetails(json: badJSON)
        XCTAssertTrue(flickrPhotoDetails == nil)
    }
    
    func testPhotoProperties() {
        flickrPhotoDetails = FlickrPhotoDetails(json: json)
        let titleExpectation = "title of this photo"
        let titleResult = flickrPhotoDetails!.title
        let descriptionExpectation = "description of this photo"
        let descriptionResult = flickrPhotoDetails!.description
        XCTAssertTrue(titleResult == titleExpectation)
        XCTAssertTrue(descriptionExpectation == descriptionResult)
    }
    
}


