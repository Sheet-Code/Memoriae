//
//  ThemeRepository.swift
//  Memoriae
//
//  Created by panandafog on 06.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import RealmSwift

protocol ThemeRepository {

    static func saveTheme(tintColor: UIColor)
    static func getTheme() -> UIColor
}

final class ThemeRepositoryImpl {

    var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Realm can't be created")
        }
    }

    static func saveTheme(theme: Theme) {

        let repo = ThemeRepositoryImpl()

        repo.save(theme: theme)

    }

    static func get() -> Theme? {

        let repo = ThemeRepositoryImpl()
        let res = Array(repo.get())

        if res.isEmpty {
            return nil
        } else {
            return res[0]
        }
    }

    static func delete() {

        let repo = ThemeRepositoryImpl()
        repo.delete()
    }

    func save(theme: Theme) {

        try? realm.write {

            let object = Theme()
            object.id = theme.id
            object.tintColor = theme.tintColor
            realm.add(object, update: .modified)
        }
    }

    func get() -> Results<Theme> {

        realm.objects(Theme.self)
    }

    func delete() {

        try? realm.write {
            realm.deleteAll()
        }
    }
}
