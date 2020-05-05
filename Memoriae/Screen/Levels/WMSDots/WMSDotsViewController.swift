//
//  WMSDotsViewController.swift
//  Memoriae
//
//  Created by panandafog on 05.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class WMSDotsViewController: UIViewController, LevelViewController {

    private var level: Level?
    private var dotsCount: Int?
    private var dots: [UIButton] = []

    private var commonDotsCount = 7
    private var diameter = 60

    @IBOutlet var dotsView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let count = dotsCount else {
            return
        }

        for _ in 1 ... count {
            dots.append(createDot())
        }

        let dotsPositions = PointsGenerator.scatterObjects(area: dotsView.frame.size,
                                                          size: CGSize(width: diameter, height: diameter),
                                                          quantity: count)

        for index in 0 ... count - 1 {

            dots[index].center = dotsPositions[index]
            dotsView.addSubview(dots[index])
        }
    }

    func setTest(level: Level, difficultyIndex: Int) {
        self.level = level
        self.dotsCount = commonDotsCount - (difficultyIndex - Difficulty.standardIndex)
    }

    func createDot() -> UIButton {

        var dot = UIButton(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        dot.layer.cornerRadius = 0.5 * dot.bounds.size.width
        dot.clipsToBounds = true
        dot.backgroundColor = .systemOrange
        return dot
    }
}
