//
//  User.PublicPhotosGetter.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Users {
    
    class PublicPhotosGetter : URLRequestOptionsOwner,
                               HTTPGET,
                               ResponseHandler {
    
        var url = URL(string: "https://api.flickr.com/services/rest")!
        
        var encoding = RequestEncoding.url
        
        var headers: Params? = nil
        
        var bodyParams: JSON? {
            return [
                "method" : FlickrApiMethod.peoplePublicPhotos.rawValue,
                "api_key" : FlickrCredentials.apiKey,
                "format" : "json",
                "nojsoncallback" : "1",
                "user_id" : user.id
            ]
        }
        
        var timoutInterval: TimeInterval = 5
        
        private let jsonifier = DataToJSONConverter.self
        
        let user: User
        
        private var resultAction: ((Result<[FlickrPhoto]>) -> Void)?
        
        init(user: User) {
            self.user = user
        }
        
        func getPublicPhotos(resultAction: @escaping (Result<[FlickrPhoto]>) -> Void) {
            self.resultAction = resultAction
            DispatchQueue.global().async {
                let request = URLRequestBuilder(requestOptionsOwner: self).build()
                NetworkCaller(request: request, responseHandler: self).makeTheCall()
            }
        }
        
        public func success(data: Data) {
            if let json = jsonifier.json(from: data) {
                if let photosDic = (json as NSDictionary).value(forKeyPath: "photos.photo") as? [JSON] {
                    let photos = photosDic.flatMap { FlickrPhoto(json: $0) }
                    DispatchQueue.main.async {
                        self.resultAction?(Result.success(photos))
                    }
                }
                
            }
        }
        
        public func failure(status: NetworkStatus, data: Data?) {
            print("failure \(data)")
            if let data = data {
                let json = jsonifier.json(from: data)
                print("json: \(json)")
                
            }
        }
    }
}
