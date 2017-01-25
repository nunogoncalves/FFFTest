//
//  NetworkStatus.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

public enum NetworkStatus : Int {
    
    case ok = 200
    
    case timeout = -1001
    case offline = -1009
    case hostNameNotFound = -1003
    
    case couldNotConnectToServer = -1004
    
    case unauthorized = 401
    case notFound = 404
    case serverError = 500
    
    case noDataError = -1
    case parseError = -2
    case genericError = -100
    
    static let technicalErrorMessage = "There was a technical problem."
    
    var description: String {
        switch self {
        case .ok:                return "Ok"
        case .timeout:           return "Request exceded wait time."
        case .offline:           return "Connection appears to be offline."
        case .notFound:          return "The resource you are looking for doesn't exist."
        case .unauthorized:      return "Unauthorized request."
        case .noDataError:       return "No data"
        case .parseError:        return "Parse data error"
        case .hostNameNotFound, .couldNotConnectToServer, .serverError, .genericError:
            return NetworkStatus.technicalErrorMessage
        }
    }
    
    static func message(for statusCode: Int) -> String {
        return NetworkStatus(rawValue: statusCode)?.description ?? technicalErrorMessage
    }
    
    var wasSuccessfull: Bool {
        return self == .ok
    }
    
}
