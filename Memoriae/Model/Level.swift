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
    let targets: [Target]?
}

// MARK: - Target
struct Target: Codable {
    let picture: String
    let time: Int
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let question: String
    let rightAnswer: Int
    let answers: [String]
}
