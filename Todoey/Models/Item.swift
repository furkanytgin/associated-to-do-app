//
//  Item.swift
//  Todoey
//
//  Created by furkan yetgin on 2.05.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    
    var categoryParent = LinkingObjects(fromType: Category.self, property: "items")
}
