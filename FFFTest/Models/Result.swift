//
//  Result.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

enum Result<T> {
    
    case success(T)
    case failure(FFError)
    
}
