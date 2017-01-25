//
//  ResponseHandler.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

public protocol ResponseHandler {
    
    func success(data: Data)
    func failure(status: NetworkStatus, data: Data?)
    
}
