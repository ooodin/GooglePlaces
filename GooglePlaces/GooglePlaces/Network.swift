//
//  Network.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 06/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import Moya
import Argo

let imageCache = NSCache<AnyObject, AnyObject>()

class Network {
    
    class func firstPage(latitude: Double, longitude: Double, completion: (([PlaceModel], String) -> Void)?) {
        
        let target: GooglePlaces = .listPlaces(latitude: latitude, longitude: longitude)
        
        self.request(target: target) { (error, response) in
            if response == nil, let error = error {
                self.processError(error: error)
            } else {
                self.listPlaces(data: response!.data, completion: completion)
            }
        }
    }
    
    class func nextPage(pageToken: String, completion: (([PlaceModel], String) -> Void)?) {
        
        let target: GooglePlaces = .listPlacesNextPage(pageToken: pageToken)
        
        self.request(target: target) { (error, response) in
            if response == nil, let error = error {
                self.processError(error: error)
            } else {
                self.listPlaces(data: response!.data, completion: completion)
            }
        }
    }
    
    class func listPlaces(data: Data, completion: (([PlaceModel], String) -> Void)?) {
        do {
            let json = JSON(try! JSONSerialization.jsonObject(with: data))
            let placesJSON = try decodedJSON(json, forKey: "results").dematerialize()
            
            let tokenJSON = try decodedJSON(json, forKey: "next_page_token").dematerialize()
            let pageToken = try String.decode(tokenJSON).dematerialize()
            
            let result = [PlaceModel].decode(placesJSON)
            switch result {
            case let .success(places):
                completion?(places, pageToken)
            case let .failure(error):
                self.processError(error: (error: error, statusCode: nil))
            }
            
        } catch(let error) {
            self.processError(error: (error: error, statusCode: nil))
        }
    }
    
    class func photo(reference: String, completion: ((UIImage) -> Void)?) {
        
        if let cachedImage = imageCache.object(forKey: reference as NSString) as? UIImage {
            completion?(cachedImage)
            return
        }
        
        let target: GooglePlaces = .photo(reference: reference)
        
        self.request(target: target) { (error, response) in
            if response == nil, let error = error {
                self.processError(error: error)
            } else {
                if let image = UIImage(data: response!.data) {
                    imageCache.setObject(image, forKey: reference as AnyObject)
                    completion?(image)
                }
            }
        }
    }
    
}

extension Network {
    
    class func request(
        target: GooglePlaces,
        completion: @escaping ((_ error:(error: Swift.Error, statusCode: Int?)?, _ response: Response?)->())
        )
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let provider = MoyaProvider<GooglePlaces>()//plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
        
        provider.request(target, completion: { (result) in
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    completion(nil, response)
                } catch {
                    completion((error: error, statusCode: response.statusCode), nil)
                }
                
            case let .failure(error):
                completion((error: error, statusCode: error.response?.statusCode), nil)
                self.processError(error: (error: error, statusCode: error.response?.statusCode))
            }
        })
    }
    
    class func processError(error:(error:Swift.Error, statusCode:Int?)) {
        if let statusCode = error.statusCode {
            print("Network request error: \(error.error.localizedDescription), status code: \(statusCode)")
        } else {
            print("Network request error: \(error.error.localizedDescription)")
        }
    }
    
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

