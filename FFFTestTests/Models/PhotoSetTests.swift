//
//  PhotoSetTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class PhotoSetTests: XCTestCase {
    
    func testEmptyPhotoSet() {
    
        let emptyPhotoSet = PhotoSet.empty
        
        XCTAssertTrue(emptyPhotoSet.currentPage == 0)
        XCTAssertTrue(emptyPhotoSet.totalPages == 0)
        XCTAssertTrue(emptyPhotoSet.isEmpty)
        XCTAssertTrue(emptyPhotoSet.hasMorePages == false)
        XCTAssertTrue(emptyPhotoSet.isFirstPage == false)
        XCTAssertTrue(emptyPhotoSet.photos.count == 0)
        
    }
    
    func testTwoPagesPhotoSet() {
        let json: JSON = [
            "id" : "123",
            "farm" : 456,
            "server" : "serverValue",
            "secret" : "secretValue"
        ]
        let flickrPhotos: [FlickrPhoto] = Array(1...100).flatMap { _ in FlickrPhoto(json: json) }
        let flickPhotoSet = PhotoSet(currentPage: 1, totalPages: 2, photos: flickrPhotos)
        
        XCTAssertTrue(flickPhotoSet.totalPages == 2)
        XCTAssertTrue(flickPhotoSet.isFirstPage == true)
        XCTAssertTrue(flickPhotoSet.isLastPage == false)
        XCTAssertTrue(flickPhotoSet.photos.count == 100)
    }
    
}
