//
//  DataToJSONConverter.swift
//  FFFTest
//
//  Created by Nuno Gonçalves on 25/01/17.
//  Copyright © 2017 Nuno Gonçalves. All rights reserved.
//

import Foundation

public struct DataToJSONConverter {
    
    public static func json(from data: Data?) -> JSON? {
        if let data = data {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
            } catch {
                print("failed \(error)")
                return nil
            }
        }
        return nil
    }
    
}
