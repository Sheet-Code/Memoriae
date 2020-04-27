//
//  Level.swift
//  Memoriae
//
//  Created by panandafog on 26.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation

class Level: Decodable {

    enum Kind: String, Decodable {
        case WMSNumbers, WMSPictures
    }
    
    let id: Int
    let title: String
    let kind: Kind

    let task: String?
    let description: String?
    let image: String?

    init(id: Int, title: String, kind: Kind, description: String?, task: String?, image: String?) {
        self.id = id
        self.title = title
        self.kind = kind
        self.description = description
        self.task = task
        self.image = image
    }
}
