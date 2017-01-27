//
//  URLRequestBuilderTests.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class URLRequestBuilderTests: XCTestCase {
    
    private struct FakeRequestOwner : URLRequestOptionsOwner {
        var url: URL = URL(string: "https://api.flickr.com/services/rest")!
        var httpMethod = HTTPMethod.get
        var headers: Params? = ["header_key" : "header value"]
        var bodyParams: JSON? = ["body_key" : ["sub_key" : "sub_value"]]
        var encoding: RequestEncoding = .json
        var timoutInterval: TimeInterval = 5
    }
    
    func testWithRequestOptionsOwner() {
        let requestOptionsOwner = FakeRequestOwner()
        let request = URLRequestBuilder(requestOptionsOwner: requestOptionsOwner).build()
        
        XCTAssert(request.url == requestOptionsOwner.url, "expected \(requestOptionsOwner.url), got \(request.url)")
        let json = try! JSONSerialization.jsonObject(with: request.httpBody!, options: .allowFragments) as! JSON
        
        XCTAssert((json["body_key"] as! [String : String])["sub_key"] == "sub_value")
        
        XCTAssert(request.value(forHTTPHeaderField: "header_key") == "header value")
    }

    func testUrlWithJSONBody() {
        let url = URL(string: "https://api.flickr.com/services/rest")!
        
        let headers = ["header_key" : "header value"]
        let body: JSON = ["body_key" : ["sub_key" : "sub_value"]]
        
        let request = URLRequestBuilder(url: url,
                                        httpMethod: .get,
                                        headers: headers,
                                        bodyParams: body,
                                        encoding: .json,
                                        timeoutInterval: 5).build()
        
        XCTAssert(request.url == url, "expected \(url), got \(request.url)")
        let json = try! JSONSerialization.jsonObject(with: request.httpBody!, options: JSONSerialization.ReadingOptions.allowFragments) as! JSON
        
        XCTAssert((json["body_key"] as! [String : String])["sub_key"] == "sub_value")
        
        XCTAssert(request.value(forHTTPHeaderField: "header_key") == "header value")
    }
    
    func testURLWithQueryParams() {
        let url = URL(string: "https://api.flickr.com/services/rest")!
        
        let headers = ["header_key" : "header value"]
        let body = ["body_key" : ["sub_key" : "sub_value"]]
        
        let request = URLRequestBuilder(url: url,
                                        httpMethod: .get,
                                        headers: headers,
                                        bodyParams: body,
                                        encoding: .url,
                                        timeoutInterval: 5).build()
        let expectedURL = URL(string: "https://api.flickr.com/services/rest?body_key%5Bsub_key%5D=sub_value")!
        
        XCTAssert(request.url! == expectedURL, "expected \(expectedURL), got \(request.url!)")
        
    }
    
}
