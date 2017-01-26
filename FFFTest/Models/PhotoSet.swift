//
//  PhotoSet.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct PhotoSet {
    
    let currentPage: Int
    let totalPages: Int
    let photos: [FlickrPhoto]
    
    var hasMorePages: Bool {
        return currentPage == totalPages
    }
    
    var isFirstPage: Bool {
        return currentPage == 1
    }
    
    static let empty = PhotoSet(currentPage: 0, totalPages: 0, photos: [])
    
    var isEmpty: Bool {
        return photos.count == 0
    }
}
