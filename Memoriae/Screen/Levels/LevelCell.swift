//
//  LevelCell.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

class LevelCell: UITableViewCell {
    static var viewController: UIViewController?
    @IBOutlet private var title: UILabel!
    @IBOutlet private var picture: UIImageView!
    @IBOutlet private var descript: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        picture.image = nil
        title.text = nil
        descript.text = nil
    }

    func setup(with level: Level, controller: MainViewController, index: IndexPath) {
        title.text = level.title
        descript.text = level.description

        picture.layer.cornerRadius = 8.0
        picture.clipsToBounds = true

        guard let picture = level.picture else {
            return
        }

        self.picture.image = ResourcesManager.getImage(name: picture)
    }
}
