//
//  PlaceModel.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 06/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import RealmSwift

import Curry
import Runes
import Argo

final class PlaceModel: Object {
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var place_id: String = ""
    
    let photos = List<PhotoModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

extension PlaceModel: Decodable {
    
    class func create(id: String, name: String, place_id: String, photos: [PhotoModel]?) -> PlaceModel {
        return PlaceModel(value: ["id": id, "name": name, "place_id": place_id, "photos": photos ?? []])
    }
    
    static func decode(_ json: Argo.JSON) -> Decoded<PlaceModel> {
        return curry(PlaceModel.create)
            <^> json <| "id"
            <*> json <| "name"
            <*> json <| "place_id"
            <*> json <||? "photos"
    }
}
