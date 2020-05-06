//
//  SelectingColorCell.swift
//  Memoriae
//
//  Created by panandafog on 06.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class SelectingColorCell: UITableViewCell, SettingsCell {

    @IBOutlet private var label: UILabel!
    
    override func prepareForReuse() {

        super.prepareForReuse()
        label.text = nil
    }

    func setup(with details: SettingsCellDetails) {

        switch details {

        case .switcher:

            break

        default:

            break
        }
    }
}
