//
//  Category.swift
//  Todoy
//
//  Created by Kamrul Hassan Sabuj on 1/10/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
