//
//  Difficulty.swift
//  Memoriae
//
//  Created by panandafog on 30.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

enum Difficulty {

    static let multipliers: [Float] = [1.4, 1.2, 1.0, 0.8, 0.6, 0.4]
    static let names: [String] = ["vegetable", "goof", "regular", "respectable", "megamind", "insane"]

    static var standardIndex = 2
    static var standardMultiplier: Float {
        multipliers[standardIndex]
    }
    static var standardName: String {
        names[standardIndex]
    }
}
