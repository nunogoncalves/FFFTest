//
//  User.PublicPhotosGetter.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

extension Users {
    
    final class PublicPhotosGetter : URLRequestOptionsOwner,
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
                "user_id" : user.id,
                "page" : page
            ]
        }
        
        var timoutInterval: TimeInterval = 5
        
        private let jsonifier = DataToJSONConverter.self
        
        private let user: User
        private var page = 0
        
        private var resultAction: ((Result<PhotoSet>) -> Void)?
        
        init(user: User) {
            self.user = user
        }
        
        func getPublicPhotos(in page: Int = 0, resultAction: @escaping (Result<PhotoSet>) -> Void) {
            self.resultAction = resultAction
            self.page = page
            DispatchQueue.global(qos: .userInteractive).async {
                let request = URLRequestBuilder(requestOptionsOwner: self).build()
                NetworkCaller(request: request, responseHandler: self).makeTheCall()
            }
        }
        
        func success(data: Data) {
            if let json = jsonifier.json(from: data),
                let resultDic = json["photos"] as? JSON,
                let photosDic = resultDic["photo"] as? [JSON],
                let currentPage = resultDic["page"] as? Int,
                let totalPages = resultDic["pages"] as? Int {
                
                let photos = photosDic.flatMap { FlickrPhoto(json: $0) }
                let photoSet = PhotoSet(currentPage: currentPage, totalPages: totalPages, photos: photos)
                DispatchQueue.main.async {
                    self.resultAction?(Result.success(photoSet))
                }
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.resultAction?(Result<PhotoSet>.failure(.notParseable))
                }
            }
        }
    
        func failure(status: NetworkStatus, data: Data?) {
            if status == .offline {
                DispatchQueue.main.async { [weak self] in
                    self?.resultAction?(Result<PhotoSet>.failure(.noNetwork))
                }
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.resultAction?(Result<PhotoSet>.failure(.generic))
            }
        }
    }
}
