//
//  WMSAreasViewController.swift
//  Memoriae
//
//  Created by panandafog on 08.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class WMSAreasViewController: UIViewController, LevelViewController {

    // MARK: Time

    private let testTime = 20.0
    private let commonSelectDuration = 2.0
    private let commonIntervalDuration = 0.1
    private let animationIntroDuration = 0.2
    private let selectTickDuration = 0.01

    private var selectDuration: Double?
    private var intervalDuration: Double?

    // MARK: Counters

    private var testCounter = 0
    private var selectCounter = 0.0
    private var selectSummaryCounter = 0.0
    private var correctTapSummaryCounter = 0.0

    // MARK: Colors

    private let notEvenButtonColor = UIColor.systemGray4
    private let evenButtonColor = UIColor.systemGray5

    // MARK: Level & Score

    private var level: Level?
    private var difficultyIndex: Int?

    // MARK: Stacks & Buttons

    private let areasInStackCount = 4
    private let commonSelectedButtonsCount = 10
    private var selectedButtonsCount: Int?

    private var buttons = [IndexedUIButton]()
    private var currentSelectedIndex: Int?
    private var currentTappedIndex: Int?
    private var isTappedJustNow = false

    @IBOutlet private var leftStack: UIStackView!
    @IBOutlet private var rightStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        var light = false

        for index in 0 ... areasInStackCount - 1 {

            let button = IndexedUIButton(type: .system)
            leftStack.addArrangedSubview(button)

            if light {
                button.backgroundColor = notEvenButtonColor
            } else {
                button.backgroundColor = evenButtonColor
            }

            buttons.append(button)
            button.setIndex(index: index)
            button.addTarget(self, action: #selector(WMSAreasViewController.tap(sender:)), for: .touchDown)
            button.addTarget(self, action: #selector(WMSAreasViewController.untap(sender:)), for: .touchUpInside)

            light.toggle()
        }

        light.toggle()

        for index in 0 ... areasInStackCount - 1 {

            let button = IndexedUIButton(type: .system)
            rightStack.addArrangedSubview(button)

            if light {
                button.backgroundColor = notEvenButtonColor
            } else {
                button.backgroundColor = evenButtonColor
            }

            buttons.append(button)
            button.setIndex(index: index + areasInStackCount)
            button.addTarget(self, action: #selector(WMSAreasViewController.tap(sender:)), for: .touchDown)
            button.addTarget(self, action: #selector(WMSAreasViewController.untap(sender:)), for: .touchUpInside)

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
        selectDuration = commonSelectDuration * Double(Difficulty.multipliers[difficultyIndex])
        intervalDuration = commonIntervalDuration
        selectedButtonsCount = Int (testTime / (selectDuration! + intervalDuration!))
    }

    func startTest() {

        guard let nNSelectDuration = selectDuration, let nNIntervalDuration = intervalDuration else {
            return
        }

        testCounter = 0

        Timer.scheduledTimer(timeInterval: nNSelectDuration + nNIntervalDuration,
                             target: self,
                             selector: #selector(self.onTestTick),
                             userInfo: nil,
                             repeats: true)
    }

    @objc func onTestTick(timer: Timer) {

        if testCounter == selectedButtonsCount {

            timer.invalidate()

            guard let selectedCount = selectedButtonsCount else {
                return
            }

            selectSummaryCounter -= animationIntroDuration * 2 * Double(selectedCount)

        } else {

            selectButton(index: Int.random(in: 0 ... buttons.count - 1))

        }

        testCounter += 1

    }

    func tapButton(index: Int) {

        if buttons.count > index {

            UIView.animate(withDuration: animationIntroDuration,
                           animations: {
            })
        }
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

                            var colorIndex = index

                            if colorIndex > self.areasInStackCount - 1 {
                                colorIndex += 1
                            }

                            if colorIndex.isEven() {
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

        Timer.scheduledTimer(timeInterval: selectTickDuration,
                             target: self,
                             selector: #selector(self.onSelectTick),
                             userInfo: nil,
                             repeats: true)
    }

    @objc func onSelectTick(timer: Timer) {

        guard let duration = selectDuration, let index = currentSelectedIndex else {
            return
        }

        selectCounter += selectTickDuration

        if currentTappedIndex == currentSelectedIndex {
            correctTapSummaryCounter += selectTickDuration

            if isTappedJustNow {
                isTappedJustNow = false
            } else {

            }
        }

        if selectCounter >= duration - selectTickDuration {

            timer.invalidate()
            selectSummaryCounter += selectCounter
            selectCounter = 0
            deHighlightButton(index: index)

        }
    }

    @objc func tap(sender: IndexedUIButton) {

        guard let index = sender.getIndex() else {
            return
        }

        tapButton(index: index)

        currentTappedIndex = index
        isTappedJustNow = true
    }

    @objc func untap(sender: IndexedUIButton) {

        currentTappedIndex = nil
    }
}
