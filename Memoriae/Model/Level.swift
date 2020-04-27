//
//  Level.swift
//  Memoriae
//
//  Created by panandafog on 26.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

//import Foundation
//
//struct Level: Decodable {
//
//    let id: Int
//    let title: String
//
//    let kind: String
//    let target: TOMMPictureTarget?
//
//    let task: String?
//    let description: String?
//    let picture: String?
//}
//
//struct TOMMPictureTarget: Decodable {
//    let picture: String
//    let time: Int
//    let questions: [Question]
//}
//
//struct Question: Decodable {
//    let question: String
//    let rightAnswer: String
//    let answers: [String]
//}

import Foundation

// MARK: - LevelElement
struct Level: Codable {
    let id: Int
    let title, kind, task, description: String
    let picture: String?
    let target: Target?
}

// MARK: - Target
struct Target: Codable {
    let picture: String
    let time: Int
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let question, rightAnswer: String
    let answers: [String]
}
