//
//  Score.swift
//  Memoriae
//
//  Created by panandafog on 30.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import RealmSwift

class Score: Object {

    @objc dynamic var id = 0
    @objc dynamic var levelId = 0
    @objc dynamic var points = 0.0
    @objc dynamic var difficulty = 0.0

    convenience init(id: Int, levelId: Int, points: Double, difficulty: Double) {
        self.init()
        self.id = id
        self.levelId = levelId
        self.points = points
        self.difficulty = difficulty
    }

    override class func primaryKey() -> String? {
        "id"
    }
}
