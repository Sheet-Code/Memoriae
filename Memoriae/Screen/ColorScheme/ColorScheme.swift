//
//  ColorScheme.swift
//  Memoriae
//
//  Created by panandafog on 06.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

enum ColorScheme {

    static var tintColor: UIColor {

        let theme = ThemeRepositoryImpl.get()
        if theme != nil {

            print()
            return UIColor.color(withCodedString: theme?.tintColor ?? "") ?? UIColor.systemOrange

        } else {
            return .systemOrange
        }
    }

    static func changeColor(to color: UIColor) {

        ThemeRepositoryImpl.saveTheme(theme: Theme(tintColor: color))
    }
}
