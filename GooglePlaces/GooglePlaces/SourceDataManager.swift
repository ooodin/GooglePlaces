//
//  SourceDataManager.swift
//  GooglePlaces
//
//  Created by Artem Semavin on 09/08/2017.
//  Copyright © 2017 Artem Semavin. All rights reserved.
//

import Foundation
import RealmSwift

protocol SourceDataManager {
    
    func addObjects(_ newPlaces: [Object])
    func readObjects<T: Object>(type: T.Type, completion: (([T]) -> Void))
    
}

final class SourceDataManagerImp: SourceDataManager {
    
    let realm: Realm?
    
    init() {
        
        do {
            realm = try Realm()
        } catch(let error) {
            realm = nil
            print("Error realm init: ", error.localizedDescription)
        }
        
        print("REALM DATA BASE PATH: ", Realm.Configuration.defaultConfiguration.fileURL?.path ?? "")
    }
    
    func addObjects(_ newObjects: [Object]) {
        
        guard let realm = self.realm else { return }
        
        do {
            try realm.write {
                realm.add(newObjects, update: true)
            }
        } catch(let error) {
            print("Error realm write operation: ", error.localizedDescription)
        }
        
    }
    
    func readObjects<T: Object>(type: T.Type, completion: (([T]) -> Void)) {
        
        guard let realm = self.realm else { return }
        
        let objects = Array(realm.objects(type))
        completion(objects)
    }
    
}
