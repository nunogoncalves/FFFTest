//
//  FlickrPhotoDetails.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 26/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct FlickrPhotoDetails {
    
    let title: String
    let description: String
    
    init?(json: JSON) {
        let nsJSON = json as NSDictionary
        guard let title = nsJSON.value(forKeyPath: "title._content") as? String,
            let description = nsJSON.value(forKeyPath: "description._content") as? String
        else { return nil }
        
        self.title = title
        self.description = description
    }
}
