//
//  UrlRequestBuilder.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

protocol URLRequestOptionsOwner {
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var headers: Params? { get }
    var bodyParams: JSON? { get }
    var encoding: RequestEncoding { get }
    var timoutInterval: TimeInterval { get }
}

struct URLRequestBuilder {
    
    private let url: URL
    private let httpMethod: HTTPMethod
    private let headers: Params?
    private let bodyParams: JSON?
    private var timoutInterval: TimeInterval
    private var encoding: RequestEncoding
    
    init(requestOptionsOwner: URLRequestOptionsOwner) {
        self.url = requestOptionsOwner.url
        self.httpMethod = requestOptionsOwner.httpMethod
        self.headers = requestOptionsOwner.headers
        self.bodyParams = requestOptionsOwner.bodyParams
        self.timoutInterval = requestOptionsOwner.timoutInterval
        self.encoding = requestOptionsOwner.encoding
    }
    
    init(url: URL,
         httpMethod: HTTPMethod = .get,
         headers: Params? = nil,
         bodyParams: JSON? = nil,
         encoding: RequestEncoding,
         timeoutInterval: TimeInterval = 5) {
        self.url = url
        self.httpMethod = httpMethod
        self.headers = headers
        self.bodyParams = bodyParams
        self.timoutInterval = timeoutInterval
        self.encoding = encoding
    }
    
    public func build() -> URLRequest {
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringCacheData,
                                    timeoutInterval: timoutInterval)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        if let headers = headers {
            urlRequest.set(headers: headers)
        }
        
        if let bodyParams = bodyParams {
            urlRequest.set(bodyParams: bodyParams, with: encoding)
        }
        
        return urlRequest
    }
    
}
