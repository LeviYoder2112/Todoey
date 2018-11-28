//
//  Category.swift
//  Todoey
//
//  Created by Levi Yoder on 11/27/18.
//  Copyright © 2018 Levi Yoder. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var title = ""
    let items = List<Item>()
}
