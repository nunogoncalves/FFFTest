//
//  URLRequest.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

public extension URLRequest {
    
    mutating func set(headers: [String : String]) {
        for headerKey in headers.keys {
            setValue(headers[headerKey], forHTTPHeaderField: headerKey)
        }
    }
    
    mutating func set(bodyParams: JSON, with encoding: RequestEncoding = .json) {
        switch encoding {
        case .url:
            guard url != nil,
                var urlComponents = URLComponents(url: url!, resolvingAgainstBaseURL: false)
            else { return }
            
            let urlComponentsWithAmpersand = urlComponents.percentEncodedQuery.map { $0 + "&" } ?? ""
            
            let percentEncodedQuery = urlComponentsWithAmpersand + encodedUrlString(with: bodyParams)
            urlComponents.percentEncodedQuery = percentEncodedQuery
            url = urlComponents.url
        case .json:
            let data = try! JSONSerialization.data(withJSONObject: bodyParams, options: .prettyPrinted)
            httpBody = data
        }
    }
}

fileprivate extension URLRequest {
    
    //These three functions were a taken from Alamofire with just a few changes.
    func encodedUrlString(with parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(key, value)
        }
        
        return (components.map { "\($0)=\($1)" } as [String]).joined(separator: "&")
    }
    
    func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents("\(key)[\(nestedKey)]", value)
            }
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents("\(key)[]", value)
            }
        } else {
            components.append((key.escaped(), "\(value)".escaped()))
        }
        
        return components
    }
    
}

fileprivate extension String {
    func escaped() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
}
