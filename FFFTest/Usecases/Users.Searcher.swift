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
        
        var caller: NetworkCaller!
        
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
            
            DispatchQueue.global(qos: .userInteractive).async {
                let request = URLRequestBuilder(requestOptionsOwner: self).build()
                if let caller = self.caller {
                    caller.makeTheCall()
                } else {
                    NetworkCaller(request: request, responseHandler: self).makeTheCall()
                }
            }
        }
    
        public func success(data: Data) {
            if let userJson = jsonifier.json(from: data)?["user"] as? JSON {
                if let user = User(json: userJson) {
                    DispatchQueue.main.async { [weak self] in
                        self?.resultAction?(Result<User>.success(user))
                    }
                } else {
                    DispatchQueue.main.async { [weak self] in
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
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.resultAction?(Result<User>.failure(.noNetwork))
                }
            }
        }
    }
    
}
    
