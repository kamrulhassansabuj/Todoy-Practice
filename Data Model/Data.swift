//
//  Data.swift
//  Todoy Practice
//
//  Created by Kamrul Hassan Sabuj on 1/10/18.
//  Copyright © 2018 SahiTech. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0
}
