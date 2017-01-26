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
        private var resultAction: ((Result<User>) -> Void)?
        
        func search(by userName: String, resultAction: @escaping (Result<User>) -> Void) {
            self.userName = userName
            self.resultAction = resultAction
            let request = URLRequestBuilder(requestOptionsOwner: self).build()
            NetworkCaller(request: request, responseHandler: self).makeTheCall()
        }
    
        public func success(data: Data) {
            if let userJson = jsonifier.json(from: data)?["user"] as? JSON {
                DispatchQueue.main.async { [weak self] in
                    if let user = User(json: userJson) {
                        self?.resultAction?(Result<User>.success(user))
                    } else {
                        self?.resultAction?(Result<User>.failure(.notParseable))
                    }
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.resultAction?(Result<User>.failure(.notFound))
                }
            }
        }
        
        public func failure(status: NetworkStatus, data: Data?) {
            if status == .offline {
                DispatchQueue.main.async { [weak self] in
                    self?.resultAction?(Result<User>.failure(.noNetwork))
                }
                return
            }
            if let data = data {
                let json = jsonifier.json(from: data)
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
    
