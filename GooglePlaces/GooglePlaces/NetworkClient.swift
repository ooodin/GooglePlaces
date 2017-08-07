//
//  NetworkClient.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 06/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import Moya

extension GooglePlaces: TargetType {
    
    public var baseURL: URL {
        let baseURL = URL(string: Parameters.places.baseURL)!
        return baseURL
    }
    
    public var path: String {
        switch self {
        case .listPlaces, .listPlacesNextPage:
            return "/nearbysearch/json"
        case .photo:
            return "/photo"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .listPlaces(latitude: let latitude, longitude: let longitude):
            return NetworkParameters.listPlaces(latitude: latitude, longitude: longitude)
        case .listPlacesNextPage(pageToken: let token):
            return NetworkParameters.nextPage(pageToken: token)
        case .photo(reference: let ref):
            return NetworkParameters.photo(reference: ref)
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .request
    }
    
    public var validate: Bool {
        return false
    }
    
    public var sampleData: Data{
        switch self {
        default:
            return "".data(using:String.Encoding.utf8)!
        }
    }
    
}
