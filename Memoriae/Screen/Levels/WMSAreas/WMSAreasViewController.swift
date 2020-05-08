//
//  WMSAreasViewController.swift
//  Memoriae
//
//  Created by panandafog on 08.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class WMSAreasViewController: UIViewController, LevelViewController {

    private let areasInStackCount = 4

    private let commonSelectDuration = 2.0
    private let commonIntervalDuration = 0.3
    private let animationIntroDuration = 0.2
    private let tickDuration = 0.001

    private var selectCounter = 0.0

    private let notEvenButtonColor = UIColor.systemGray4
    private let evenButtonColor = UIColor.systemGray5

    private var currentSelectedIndex: Int?

    private var selectDuration: Double?
    private var intervalDuration: Double?

    private var level: Level?
    private var difficultyIndex: Int?

    private var buttons = [UIButton]()

    @IBOutlet private var leftStack: UIStackView!
    @IBOutlet private var rightStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var light = true

        for _ in 0 ... areasInStackCount - 1 {

            let button = UIButton(type: .system)
            leftStack.addArrangedSubview(button)

            if light {
                button.backgroundColor = notEvenButtonColor
            } else {
                button.backgroundColor = evenButtonColor
            }

            buttons.append(button)

            light.toggle()
        }

        light.toggle()

        for _ in 0 ... areasInStackCount - 1 {

            let button = UIButton(type: .system)
            rightStack.addArrangedSubview(button)

            if light {
                button.backgroundColor = notEvenButtonColor
            } else {
                button.backgroundColor = evenButtonColor
            }

            buttons.append(button)

            light.toggle()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        startTest()
    }

    func setTest(level: Level, difficultyIndex: Int) {

        self.level = level
        self.difficultyIndex = difficultyIndex
        self.selectDuration = commonSelectDuration * Double(Difficulty.multipliers[difficultyIndex])
        self.intervalDuration = commonIntervalDuration * Double(Difficulty.multipliers[difficultyIndex])
    }

    func startTest() {

        selectButton(index: 5)
    }

    func highlightButton(index: Int) {

        if buttons.count > index {

            UIView.animate(withDuration: animationIntroDuration,
                           animations: {
                            self.buttons[index].backgroundColor = ColorScheme.tintColor
            })
        }
    }

    func deHighlightButton(index: Int) {

        if buttons.count > index {

            UIView.animate(withDuration: animationIntroDuration,
                           animations: {

                            if index.isEven() {
                                self.buttons[index].backgroundColor = self.evenButtonColor
                            } else {
                                self.buttons[index].backgroundColor = self.notEvenButtonColor
                            }
            })
        }
    }

    func selectButton(index: Int) {

        highlightButton(index: index)
        currentSelectedIndex = index

        Timer.scheduledTimer(timeInterval: tickDuration,
                             target: self,
                             selector: #selector(self.onSelectTick),
                             userInfo: nil,
                             repeats: true)
    }

    @objc func onSelectTick(timer: Timer) {

        guard let duration = selectDuration, let index = currentSelectedIndex else {
            return
        }

        selectCounter += tickDuration

        if selectCounter >= duration {

            timer.invalidate()
            selectCounter = 0
            deHighlightButton(index: index)
        }
    }

}
