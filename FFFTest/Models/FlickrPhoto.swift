//
//  FlickrPhoto.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct FlickrPhoto {
    
    let id: String
    private let farmId: Int
    private let serverId: String
    let secret: String
    
    private let baseUrlString: String
    
    init?(json: JSON) {
       guard let id = json["id"] as? String,
            let farmId = json["farm"] as? Int,
            let serverId = json["server"] as? String,
            let secret = json["secret"] as? String
        else { return nil }
        
        self.farmId = farmId
        self.serverId = serverId
        self.id = id
        self.secret = secret
        baseUrlString = "https://farm\(farmId).staticflickr.com/\(serverId)/\(id)_\(secret)"
    }
    
    func url(for size: FlickrImageSize) -> URL {
        return URL(string: "\(baseUrlString)_\(size.rawValue).jpg")!
    }
}


