//
//  Theme.swift
//  Memoriae
//
//  Created by panandafog on 06.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import RealmSwift

class Theme: Object {

    @objc dynamic var id = 0
    @objc dynamic var tintColor = ""

    convenience init(id: Int, tintColor: UIColor) {

        self.init()
        self.id = id
        self.tintColor = tintColor.codedString ?? ""
    }

    convenience init(tintColor: UIColor) {

        self.init()
        self.id = 0
        self.tintColor = tintColor.codedString ?? ""
    }

    override class func primaryKey() -> String? {
        "id"
    }
}
