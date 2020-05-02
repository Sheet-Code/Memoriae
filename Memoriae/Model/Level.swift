//
//  Level.swift
//  Memoriae
//
//  Created by panandafog on 26.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation

// MARK: - LevelElement
struct Level: Codable {
    let id: Int
    let title, kind, task, description: String
    let picture: String?
    let pictureSets: [TOMMPictureSet]?
}
