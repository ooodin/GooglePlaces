//
//  NetworkRouter.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 06/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation

public enum GooglePlaces {
    case listPlaces(latitude: Double, longitude: Double)
    case listPlacesNextPage(pageToken: String)
    
    case photo(reference: String)
}
