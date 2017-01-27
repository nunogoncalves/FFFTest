//
//  NetworkCallerTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class NetworkCallerTests: XCTestCase {
    
    class TestHandler : ResponseHandler {
        
        var successCalledCount = 0
        var failureCalledCount = 0
        var exp: XCTestExpectation!
        var status: NetworkStatus?
        
        var expectation: ((XCTestExpectation) -> ()) = { _ in}
        
        func success(data: Data) {
            expectation(exp)
            successCalledCount += 1
        }
        
        func failure(status: NetworkStatus, data: Data?) {
            expectation(exp)
            self.status = status
            failureCalledCount += 1
        }
        
    }
    
    func testCallSuccess() {
        let urlRequest = URLRequest(url: URL(string: "https://api.flickr.com/services/rest")!)
        let testHandler = TestHandler()
        
        let exp = expectation(description: "wait for network call")
        testHandler.exp = exp
        
        testHandler.expectation = { expectation in
            expectation.fulfill()
        }
        
        NetworkCaller(request: urlRequest, responseHandler: testHandler).makeTheCall()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(testHandler.successCalledCount == 1)
        XCTAssertTrue(testHandler.failureCalledCount == 0)
        
    }
    
    func testCallFailure() {
        let urlRequest = URLRequest(url: URL(string: "https://xxapi.flickr.com/services/rest")!)
        let testHandler = TestHandler()
        
        let exp = expectation(description: "wait for network call")
        testHandler.exp = exp
        
        testHandler.expectation = { expectation in
            expectation.fulfill()
        }
        
        NetworkCaller(request: urlRequest, responseHandler: testHandler).makeTheCall()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(testHandler.successCalledCount == 0)
        XCTAssertTrue(testHandler.failureCalledCount == 1)
        XCTAssertTrue(testHandler.status == .hostNameNotFound, "Expected \(NetworkStatus.hostNameNotFound), got \(testHandler.status)")
        
    }
    
}
