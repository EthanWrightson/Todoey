//
//  Item.swift
//  Todoey
//
//  Created by Ethan Wrightson on 20/09/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var isCompleted : Bool = false
    @objc dynamic var dateCreated : Date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
 
