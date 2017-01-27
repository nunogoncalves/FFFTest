//
//  Users.SearcherTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class UsersSearcherTests: XCTestCase {

    let searcher = Users.Searcher()
    
    class FakeNetworkCaller : NetworkCaller {
        
        var expectation: XCTestExpectation?
        
        override func makeTheCall() {
            let json: JSON = [
                "user": [
                    "nsid" : "09213219312",
                    "username" : [
                        "_content" : "nunogoncalves"
                    ]
                ]
            ]
            let data = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            responseHandler.success(data: data)
            expectation?.fulfill()
        }
        
    }
    
    func testSuccess() {
        
        let _expectation = expectation(description: "wait for data")
        
        let url = URL(string: "https://api.flickr.com/services/rest")!
        let fakeNetworkCaller = FakeNetworkCaller(request: URLRequest(url: url), responseHandler: searcher)
        searcher.caller = fakeNetworkCaller
        fakeNetworkCaller.expectation = _expectation
        
        var name: String?
        searcher.search(by: "whatever") { result in
            switch result {
            case .success(let user):
                name = user.userName
            case .failure(_): return
            }
        }
        
        waitForExpectations(timeout: 2, handler: nil)
        
        let expectedName = Optional<String>("nunogoncalves")
        XCTAssertTrue(name == expectedName, "expected \(expectedName), got \(name)")
        
    }

    
    
}
