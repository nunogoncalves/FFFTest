//
//  UserPublicPhotosGetter.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 27/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import XCTest
@testable import FFFTest

class UsersPublicPhotosGetter: XCTestCase {
    
    static let user = User(json: ["nsid" : "09213219312", "username" : ["_content" : "nunogoncalves"]])!
    let searcher = Users.PublicPhotosGetter(user: user)
    
    class FakeNetworkCaller : NetworkCaller {
        
        var expectation: XCTestExpectation?
        
        override func makeTheCall() {
            let json: JSON = ["photos" : [
                                 "photo" : [[
                                     "id" : "123",
                                     "farm" : 345,
                                     "server" : "server_value",
                                     "secret" : "secret_value"
                                 ]],
                                 "page" : 1,
                                 "pages" : 1
                              ],
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
        
        var resultPhotoSet: PhotoSet?
        searcher.getPublicPhotos { result in
            switch result {
            case .success(let photoSet):
                resultPhotoSet = photoSet
            case .failure(_): return
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        let json: JSON = ["id" : "123", "farm" : 345, "server" : "server_value", "secret" : "secret_value"]
        let photo = FlickrPhoto(json: json)
        let expectedPhotoSet = PhotoSet(currentPage: 1, totalPages: 1, photos: [])
        let expected = Optional<PhotoSet>(expectedPhotoSet)
        
        let expectedCurrentPage = expected?.currentPage
        let resultCurrentPage = resultPhotoSet?.currentPage
        XCTAssertTrue(resultCurrentPage == expectedCurrentPage, "expected \(expectedCurrentPage), got \(resultCurrentPage)")
        
    }
    
    
    
}

