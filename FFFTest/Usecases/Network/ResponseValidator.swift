//
//  REsponseValidator.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

public struct ResponseValidator {
    
    private let data: Data?
    private let response: HTTPURLResponse?
    private let error: Error?
    
    let status: NetworkStatus
    
    public init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response as? HTTPURLResponse
        self.error = error
        
        self.status = ResponseValidator.checkStatus(from: self.response, data: data, error: error)
    }
    
    public var success: Bool {
        return status.wasSuccessfull
    }
    
    private static func checkStatus(from response: HTTPURLResponse?, data: Data?, error: Error?) -> NetworkStatus {
        
        if let error = error as? NSError, let status = NetworkStatus(rawValue: (error.code)) {
            return status
        }
        
        let status = NetworkStatus(rawValue: (response?.statusCode ?? -1)) ?? .genericError
        if status.wasSuccessfull {
            if let _ = data {
                return .ok
            }
            return status
        } else {
            return status
        }
    }
    
}
