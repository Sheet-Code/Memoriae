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

let kmaxStoredScoresPerLevel = 10

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

        var storedScores = repo.get(levelId: level.id)

        if repo.get().last == nil {

            lastId = -1

        } else {

            let max = storedScores.max { lhs, rhs in
                lhs.id < rhs.id
            }

            guard let maxById = max else {
                return
            }

            print("MAX: " + String(maxById.id))

            let curId = maxById.id
            lastId = curId
        }

        let score = Score(id: lastId + 1, levelId: level.id, points: Double(right * 100) / Double(questions.count), difficulty: Double(difficulty))

        repo.save(scores: [score])

        storedScores = repo.get(levelId: level.id)

        if storedScores.count > kmaxStoredScoresPerLevel {

            let min = storedScores.min { lhs, rhs in
                lhs.id < rhs.id
            }

            guard let minById = min else {
                return
            }

            print("MIN: " + String(minById.id))

            repo.delete(scores: [minById])
        }
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

    func get(levelId: Int) -> Results<Score> {
        realm.objects(Score.self).filter("levelId == %@", levelId)
    }

    func clear() {
        try? realm.write {
            realm.deleteAll()
        }
    }

    func count() -> Int {
        realm.objects(Score.self).count
    }

    func delete(scores: [Score]) {
        try? realm.write {
            realm.delete(scores)
        }
    }
}
