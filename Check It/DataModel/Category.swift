//
//  Category.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/20/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import Foundation
import RealmSwift
class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
