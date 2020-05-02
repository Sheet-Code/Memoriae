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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nNLevel = level else {
            return
        }

        self.navigationItem.title = nNLevel.title
        task.text = nNLevel.task
        descript.text = nNLevel.description
        self.tabBarController?.tabBar.isHidden = true
        guard let pic = level?.picture else {
            return
        }

        image.image = UIImage(named: pic)
        image.layer.cornerRadius = 8.0
        image.clipsToBounds = true

        difficultyLabel.text = Difficulty.standardName

        difficultySlider.value = Float(Difficulty.standardIndex)
        difficultySlider.minimumValue = 0
        difficultySlider.maximumValue = Float(Difficulty.multipliers.count) - 0.000001

    }

    @IBAction private func startTest(_ sender: Any) {

        guard let level = self.level else { return }

        let storyBoard = UIStoryboard(name: level.kind, bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(identifier: level.kind + "ViewController") as? LevelViewController else {
            return
        }

        newViewController.setTest(level: level, difficulty: Difficulty.multipliers[Int(difficultySlider.value)])
        navigationController?.pushViewController(newViewController, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction private func sliderValueChanged(_ sender: Any) {
        difficultyLabel.text = Difficulty.names[Int(difficultySlider.value)]
    }
}
