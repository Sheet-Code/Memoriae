//
//  ResourcesManager.swift
//  Memoriae
//
//  Created by panandafog on 03.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

enum ResourcesManager {

    private static var levelsAsset: NSDataAsset? {

        NSDataAsset(name: "levels.json")
    }

    static func getLevels() -> [Level]? {

        guard let assetData = levelsAsset?.data else {
            return nil
        }

        return try? JSONDecoder().decode([Level].self, from: assetData)
    }

    static func getImage(name: String) -> UIImage? {

        UIImage(named: name)
    }
}
