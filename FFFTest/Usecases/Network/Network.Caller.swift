//
//  Network.Caller.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

public struct NetworkCaller {
    
    private let session: URLSession
    private let request: URLRequest
    private let responseHandler: ResponseHandler
    
    private static let defaultSession = URLSession(configuration: .default)
    
    public init(session: URLSession = NetworkCaller.defaultSession,
                request: URLRequest,
                responseHandler: ResponseHandler) {
        
        self.session = session
        self.request = request
        self.responseHandler = responseHandler
    }
    
    public func makeTheCall() {
        session.dataTask(with: request, completionHandler: responseHandler).resume()
    }
    
    //TODO this actyally doesn't belong here.
    private func responseHandler(data: Data?, response: URLResponse?, error: Error?) {
        let responseValidator = ResponseValidator(data: data, response: response, error: error)
        if responseValidator.success {
            responseHandler.success(data: data!)
        } else {
            responseHandler.failure(status: responseValidator.status, data: data)
        }
    }
    
}
