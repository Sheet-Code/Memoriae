//
//  TOMMPictureData.swift
//  Memoriae
//
//  Created by panandafog on 02.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

// MARK: - TOMMPictureData
struct TOMMPictureSet: Codable {
    let picture: String
    let time: Float
    let questions: [Question]
}

// MARK: - Question
struct Question: Codable {
    let question: String
    let rightAnswer: Int
    let answers: [String]
}
