//
//  PhotoModel.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 06/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

import RealmSwift

final class PhotoModel: Object {
    
    dynamic var ref: String = ""
    dynamic var height: Int = 0
    dynamic var width: Int = 0
    
    override static func primaryKey() -> String? {
        return "ref"
    }
    
}

extension PhotoModel: Decodable {
    
    class func create(height: Int, width: Int, reference: String) -> PhotoModel {
        return PhotoModel(value: ["ref": reference, "height": height, "width": width])
    }
    
    static func decode(_ json: JSON) -> Decoded<PhotoModel> {
        return curry(PhotoModel.create)
            <^> json <| "height"
            <*> json <| "width"
            <*> json <| "photo_reference"
    }
}

