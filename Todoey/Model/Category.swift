//
//  Category.swift
//  Todoey
//
//  Created by Ethan Wrightson on 20/09/2018.
//  Copyright © 2018 Ethan Wrightson. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var title : String = ""
    
    // Create the relationship to the items inside this category
    let items = List<Item>()
    
}
