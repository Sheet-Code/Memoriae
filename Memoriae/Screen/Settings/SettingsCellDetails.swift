//
//  SettingsCellDetails.swift
//  Memoriae
//
//  Created by panandafog on 04.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

enum SettingsCellDetails {

    case action (
        title: String,
        action: Selector,
        target: SettingsViewController
    )
    case switcher
    case details
}
