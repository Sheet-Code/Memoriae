//
//  ScoreRepository.swift
//  Memoriae
//
//  Created by panandafog on 30.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import RealmSwift

protocol ScoreRepository {
    func save(_ posts: [Score])
    func get() -> Results<Score>
    func count() -> Int
    func clear()
}

final class ScoreRepositoryImpl {
    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Realm can't be created")
        }
    }

    static func saveAnswers(right: Int, level: Level, difficulty: Float, questions: [Question]) {

        let repo = ScoreRepositoryImpl()
        let lastId: Int

        if repo.get().last == nil {

            lastId = -1

        } else {

            guard let last = repo.get().last?.id else {
                return
            }

            let lastlast = Int(last)
            guard let lastlastlast = lastlast else {
                return
            }

            lastId = lastlastlast
        }

        let score = Score(id: String(lastId + 1), levelId: level.id, points: Double(right * 100) / Double(questions.count), difficulty: Double(difficulty))

        repo.save(scores: [score])
    }

    func save(scores: [Score]) {
        try? realm.write {
            scores.forEach { score in
                let object = Score()
                object.id = score.id
                object.levelId = score.levelId
                object.points = score.points
                object.difficulty = score.difficulty
                realm.add(object, update: .modified)
            }
        }
    }

    func get() -> Results<Score> {
        realm.objects(Score.self)
    }

    func clear() {
        try? realm.write {
          realm.deleteAll()
        }
    }

    func count() -> Int {
        realm.objects(Score.self).count
    }
}
