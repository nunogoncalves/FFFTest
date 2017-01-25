//
//  UsersSearcher.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Users {
    
    class Searcher: URLRequestOptionsOwner,
                    HTTPGET,
                    ResponseHandler {
    
        var url = URL(string: "https://api.flickr.com/services/rest")!
        
        var encoding = RequestEncoding.url
        
        var headers: Params? = nil
        var bodyParams: JSON? {
            return [
                "method" : FlickrApiMethod.peopleFindByName.rawValue,
                "api_key" : FlickrCredentials.apiKey,
                "format" : "json",
                "nojsoncallback" : "1",
                "username" : userName
            ]
        }
        var timoutInterval: TimeInterval = 5
        
        private let jsonifier = DataToJSONConverter.self
        
        private var userName: String = ""
        
        func search(by userName: String, resultAction: @escaping (Result<[User]>) -> Void) {
            self.userName = userName
            let request = URLRequestBuilder(requestOptionsOwner: self).build()
            NetworkCaller(request: request, responseHandler: self).makeTheCall()
        }
    
        public func success(data: Data) {
            print("success", data)
            if let json = jsonifier.json(from: data) {
                print(json)
//                let object = User(json)
//                if let object = object {
//                    resultAction(Result<[User]>.success(object))
//                } else {
//                    let responseError = ResponseError(networkStatus: .ok, responseDictionary: json)
//                    log(responseError: responseError)
//                    log("failed to parse Person")
//                    resultAction(Result<[Person]>.failure(responseError))
//                }
//            } else {
//                let responseError = ResponseError(networkStatus: .parseError, responseDictionary: nil)
//                log(responseError: responseError)
//                resultAction(Result<[Person]>.failure(responseError))
            }
        }
        
        public func failure(status: NetworkStatus, data: Data?) {
            print("failure", status)
            print("failure", data)
            if let data = data {
                let json = jsonifier.json(from: data)
                print(json)
//                let responseError = ResponseError(networkStatus: status, responseDictionary: json)
//                log(responseError: responseError)
//                resultAction(Result<[Person]>.failure(responseError))
//            } else {
//                let responseError = ResponseError(networkStatus: status, responseDictionary: nil)
//                log(responseError: responseError)
//                resultAction(Result<[Person]>.failure(responseError))
            }
        }
    }
    
}
    
