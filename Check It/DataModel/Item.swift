//
//  Item.swift
//  Check It
//
//  Created by Andrew Aguilar on 8/20/19.
//  Copyright © 2019 Andrew Aguilar. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var complete: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
