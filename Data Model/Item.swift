//
//  Item.swift
//  Todoy
//
//  Created by Kamrul Hassan Sabuj on 1/10/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title  : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var currentTime : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
