//
//  GroceryItem.swift
//  FireFun
//
//  Created by Tran Ngoc Nam on 7/2/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import FirebaseDatabase

typealias DICT = Dictionary<AnyHashable, Any>

class Student {
    let ref: DatabaseReference?
    let id: Int
    let name: String
    let age: Int
    let address: String

    init(id: Int, name: String, age: Int, address: String) {
        ref = nil
        self.id = id
        self.name = name
        self.age = age
        self.address = address
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? DICT else { return nil }
        guard let id = value["id"] as? Int else { return nil }
        guard let name = value["name"] as? String else { return nil }
        guard let age = value["age"] as? Int else { return nil }
        guard let address = value["address"] as? String else { return nil }
        
        ref = snapshot.ref
        self.id = id
        self.name = name
        self.age = age
        self.address = address
    }
    
    func toAnyObject() -> Any {
        return [
            "id": id,
            "name": name,
            "age": age,
            "address": address
        ]
    }
}
