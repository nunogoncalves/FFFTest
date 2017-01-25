//
//  User.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

struct User {
    
    let id: String
    let userName: String
    
    init?(json: JSON) {
        guard let id = json["nsid"] as? String,
            let userName = (json as NSDictionary).value(forKeyPath: "username._content") as? String
        else { return nil }
        
        self.id = id
        self.userName = userName
    }
    
}
