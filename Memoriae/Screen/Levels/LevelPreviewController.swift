//
//  LevelPreviewController.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import Foundation
import UIKit

class LevelPreviewController: UIViewController {

    var level: Level?

    @IBOutlet private var task: UILabel!
    @IBOutlet private var descript: UILabel!
    @IBOutlet private var image: UIImageView!

    @IBOutlet private var difficultySlider: UISlider!
    @IBOutlet private var difficultyLabel: UILabel!

    @IBOutlet private var startButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nNLevel = level else {
            return
        }

        self.navigationItem.title = nNLevel.title
        task.text = nNLevel.task
        descript.text = nNLevel.description
        self.tabBarController?.tabBar.isHidden = true

        guard let difficulties = level?.difficulties, let standardIndex = level?.standardIndex, let name = difficulties[standardIndex].name else {
            return
        }

        difficultyLabel.text = name

        difficultySlider.value = Float(standardIndex)
        difficultySlider.minimumValue = 0
        difficultySlider.maximumValue = Float(difficulties.count) - 0.000_001

        startButton.setTitleColor(ColorScheme.tintColor, for: .init())
        difficultyLabel.textColor = ColorScheme.tintColor

        guard let pic = level?.picture else {
            return
        }

        image.image = UIImage(named: pic)
        image.layer.cornerRadius = 8.0
        image.clipsToBounds = true
    }

    @IBAction private func startTest(_ sender: Any) {

        guard let level = self.level else { return }

        let storyBoard = UIStoryboard(name: level.kind, bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(identifier: level.kind + "ViewController") as? LevelViewController else {
            return
        }

        newViewController.setTest(level: level, difficultyIndex: Int(difficultySlider.value))
        navigationController?.pushViewController(newViewController, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction private func sliderValueChanged(_ sender: Any) {
        guard let diff = level?.difficulties, let name = diff[Int(difficultySlider.value)].name else {
            return
        }
        difficultyLabel.text = name
    }
}
