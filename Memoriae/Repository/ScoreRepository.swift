//
//  ScoreRepository.swift
//  Memoriae
//
//  Created by panandafog on 30.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import RealmSwift

protocol ScoreRepository {
    static func saveAnswers(right: Int, level: Level, difficulty: Int, questions: [Question])
    static func getScores(levelId: Int) -> [Score]?
    static func clear()
}

final class ScoreRepositoryImpl {
    var realm: Realm {
        do {
            return try Realm()
        
        } catch {
            fatalError("Realm can't be created") //  po Realm.Configuration.defaultConfiguration.fileURL
        }
    }

    static func saveAnswers(points: Double, level: Level, difficulty: Int) {

        let repo = ScoreRepositoryImpl()
        let lastId: Int
        let storedScores = repo.get(levelId: level.id)

        if repo.get().last == nil {

            lastId = -1

        } else {

            let max = storedScores.max { lhs, rhs in
                lhs.id < rhs.id
            }
            
            guard let maxById = max else {
                return
            }

            let curId = maxById.id
            lastId = curId
        }

        let score = Score(id: lastId + 1, levelId: level.id, points: points, difficulty: difficulty)

        let bestStored = repo.get(levelId: level.id, difficulty: difficulty)

        if bestStored.isEmpty {

            repo.save(scores: [score])

        } else {

            let best = bestStored[0]

            if best.points < score.points {

                score.id = best.id

                repo.delete(scores: [best])
                repo.save(scores: [score])
            }
        }
    }

    static func getScores(levelId: Int) -> [Score]? {
        let repo = ScoreRepositoryImpl()
        let res = Array(repo.get(levelId: levelId))

        if res.isEmpty {
            return nil
        } else {
            return res
        }
    }

    static func clear() {
        let repo = ScoreRepositoryImpl()
        repo.clear()
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

    func get(levelId: Int, difficulty: Int) -> [Score] {
        get(levelId: levelId).filter({ $0.difficulty == difficulty })
    }

    func clear() {
        try? realm.write {
            realm.delete(get())
        }

        guard let levels = ResourcesManager.getLevels() else {
            return
        }

        var lastIndex = 0

        for levelIndex in 0...levels.count - 1 {
            guard let difficulties = levels[levelIndex].difficulties else {
                return
            }
            for difficultyIndex in 0...difficulties.count - 1 {
                save(scores: [
                    Score(id: lastIndex,
                          levelId: levels[levelIndex].id,
                          points: 0,
                          difficulty: difficultyIndex)
                ])
                lastIndex += 1
            }
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
