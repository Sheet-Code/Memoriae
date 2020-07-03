//
//  Section.swift
//  Memoriae
//
//  Created by panandafog on 01.07.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

struct Section {
    var name: String
    var items: [Level]
    var collapsed: Bool

    init(name: String, items: [Level], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}
