//
//  Data.swift
//  Todoey
//
//  Created by Levi Yoder on 11/27/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title = ""
    @objc dynamic var done = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
