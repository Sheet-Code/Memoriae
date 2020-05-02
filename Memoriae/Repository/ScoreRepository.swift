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

            var maxById = storedScores[0]
            guard var maxId = Int(storedScores[0].id) else {
                return
            }

            for index in 1...storedScores.count - 1 {
                guard let currentId = Int(storedScores[index].id) else {
                    return
                }
                if currentId > maxId {
                    maxId = currentId
                    maxById = storedScores[index]
                }
            }

            guard let curId = Int(maxById.id) else {
                return
            }
            lastId = curId
        }

        let score = Score(id: String(lastId + 1), levelId: level.id, points: Double(right * 100) / Double(questions.count), difficulty: Double(difficulty))

        repo.save(scores: [score])

        storedScores = repo.get(levelId: level.id)

        if storedScores.count > kmaxStoredScoresPerLevel {

            var minById = storedScores[0]
            guard var minId = Int(storedScores[0].id) else {
                return
            }

            for index in 1...storedScores.count - 1 {
                guard let currentId = Int(storedScores[index].id) else {
                    return
                }
                if currentId < minId {
                    minId = currentId
                    minById = storedScores[index]
                }
            }

            repo.delete(scores: [minById])
        }

        print(storedScores)
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
