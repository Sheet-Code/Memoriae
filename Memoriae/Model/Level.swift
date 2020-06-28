//
//  Level.swift
//  Memoriae
//
//  Created by panandafog on 26.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation

// MARK: - LevelElement
struct Level: Decodable {
    let id: Int
    let title, kind, task, description: String
    let picture: String?
    let pictureSets: [TOMMPictureSet]?
    let dotsSet: DotsSet?
    let standardIndex: Int?
    var difficulties: [Difficulty]?
}
