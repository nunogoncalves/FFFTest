//
//  UserTests.swift
//  UserTests
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class UserTests: XCTestCase {
    
    private let json: JSON = [
        "nsid" : "09213219312",
        "username" : [
            "_content" : "nunogoncalves"
        ]
    ]
    
    var user: User?
    
    func testUserBuilt() {
        user = User(json: json)
        XCTAssertTrue(user != nil, "Expect user to have been created")
    }
    
    func testUserNotBuiltWithEmptyJSON() {
        user = User(json: [:])
        XCTAssertTrue(user == nil, "Expect user to be nil")
    }
    
    func testUserNotBuiltWithInvalidJSON() {
        user = User(json: ["nsid": "12345",
                           "username" : [
                              "_contentXX" : "nunogoncalves"
                            ]
                          ]
        )
        XCTAssertTrue(user == nil, "Expect user to be nil")
    }
    
    func testUserProperties() {
        user = User(json: json)
        let userNameExpectation = "nunogoncalves"
        let userNameResult = user!.userName
        
        let idExpectation = "09213219312"
        let idResult = user!.id
        XCTAssertTrue(userNameResult == userNameExpectation, "Expect username to be set up")
        XCTAssertTrue(idResult == idExpectation, "Expect id to be set up")
    }
    
    
}
