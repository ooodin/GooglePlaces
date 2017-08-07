//
//  NetworkParameters.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 06/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation

struct NetworkParameters {
    
    static func listPlaces(latitude: Double, longitude: Double) -> [String: Any]? {
        
        let parameters:[String: Any] = [
            "location" : "\(latitude),\(longitude)",
            "rankby" : "distance",
            "key" : Parameters.places.apiKey
        ]
        
        return parameters
    }
    
    static func nextPage(pageToken: String) -> [String: Any]? {
        
        let parameters:[String: Any] = [
            "pagetoken" : pageToken,
            "key" : Parameters.places.apiKey
        ]
        
        return parameters
    }
    
    static func photo(reference: String) -> [String: Any]? {
        
        let parameters:[String: Any] = [
            "maxwidth" : "400",
            "photo_reference" : reference,
            "key" : Parameters.places.apiKey
        ]
        
        return parameters
    }
    
}
