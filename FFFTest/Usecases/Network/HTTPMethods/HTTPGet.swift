//
//  HTTPGet.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

protocol HTTPGET {
    var httpMethod: HTTPMethod { get }
}

extension HTTPGET {
    var httpMethod: HTTPMethod {
        return .get
    }
}
