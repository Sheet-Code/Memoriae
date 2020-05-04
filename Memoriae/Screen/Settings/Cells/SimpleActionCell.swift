//
//  SimpleActionCell.swift
//  Memoriae
//
//  Created by panandafog on 04.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class SimpleActionCell: UITableViewCell, SettingsCell {

    @IBOutlet private var button: UIButton!
    @IBOutlet private var label: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        label.text = nil
        button.titleLabel?.text = nil
        button.removeTarget(nil, action: nil, for: .allEvents)
    }

    func setup(with details: SettingsCellDetails) {

        switch details {

        case .action(title: let title, action: let action, target: let target):

            label.text = title
            button.titleLabel?.text = "test action"
            button.addTarget(target, action: action, for: .touchUpInside)

        default:

            break
        }
    }
}
