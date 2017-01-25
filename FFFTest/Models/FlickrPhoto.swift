//
//  FlickrPhoto.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct FlickrPhoto {
    
    private let farmId: Int
    private let serverId: String
    private let photoId: String
    private let secret: String
    
    init?(json: JSON) {
       guard let farmId = json["farm"] as? Int,
            let serverId = json["server"] as? String,
            let photoId = json["id"] as? String,
            let secret = json["secret"] as? String
        else { return nil }
        
        self.farmId = farmId
        self.serverId = serverId
        self.photoId = photoId
        self.secret = secret
    }
    
    func url(for size: FlickrImageSize) -> URL {
        return URL(string: "https://farm\(farmId).staticflickr.com/\(serverId)/\(photoId)_\(secret)_\(size.rawValue).jpg")!
    }
}


