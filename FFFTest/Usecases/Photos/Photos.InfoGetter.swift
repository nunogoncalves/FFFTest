//
//  Photos.InfoGetter.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 26/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Photos {
    
    final class InfoGetter : URLRequestOptionsOwner,
                             HTTPGET,
                             ResponseHandler {
        
        var url = URL(string: "https://api.flickr.com/services/rest")!
        
        var encoding = RequestEncoding.url
        
        var headers: Params? = nil
        
        var bodyParams: JSON? {
            return [
                "method" : FlickrApiMethod.getPhotoInfo.rawValue,
                "api_key" : FlickrCredentials.apiKey,
                "format" : "json",
                "nojsoncallback" : "1",
                "photo_id" : photo.id,
                "secret" : photo.secret
            ]
        }
        
        var timoutInterval: TimeInterval = 5
        
        private let jsonifier = DataToJSONConverter.self
        let photo: FlickrPhoto
        private var resultAction: ((Result<FlickrPhotoDetails>) -> Void)?
        
        init(photo: FlickrPhoto) {
            self.photo = photo
        }
        
        func getPhotoInfo(resultAction: @escaping (Result<FlickrPhotoDetails>) -> Void) {
            self.resultAction = resultAction
            DispatchQueue.global(qos: .userInteractive).async {
                let request = URLRequestBuilder(requestOptionsOwner: self).build()
                NetworkCaller(request: request, responseHandler: self).makeTheCall()
            }
        }
        
        func success(data: Data) {
            if let json = jsonifier.json(from: data),
                let photoDic = json["photo"] as? JSON,
                let photoDetails = FlickrPhotoDetails(json: photoDic) {
                DispatchQueue.main.async {
                    self.resultAction?(Result.success(photoDetails))
                }
            } else {
                DispatchQueue.main.async {
                    self.resultAction?(Result.failure(.notParseable))
                }
            }
        }
        
        func failure(status: NetworkStatus, data: Data?) {
            DispatchQueue.main.async {
                self.resultAction?(Result.failure(.notFound))
            }
        }
        
    }
}
