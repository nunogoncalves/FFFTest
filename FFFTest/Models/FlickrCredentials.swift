//
//  FlickrCredentials.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct FlickrCredentials {
    
    //IUO, I'm pretty sure this will always work. If it doesn't there's something really wrong with the app. :)
    private static let pListPath = Bundle.main.path(forResource: "Flickr", ofType: "plist")!
    
    static let apiKey = NSDictionary(contentsOfFile: pListPath)!["ApiKey"] as! String
    static let secret = NSDictionary(contentsOfFile: pListPath)!["Secret"] as! String
    
}
