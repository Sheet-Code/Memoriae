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

    // MARK: Customising

    private let notEvenButtonColor = UIColor.systemGray4
    private let evenButtonColor = UIColor.systemGray5
    private let brightnessTermWhileTapped = CGFloat(0.1)
    private let buttonCornerRadius = CGFloat(40)

    // MARK: Level & Score

    private var level: Level?
    private var difficultyIndex: Int?

    // MARK: Stacks & Buttons

    private let areasInStackCount = 5
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

        for index in 0 ... areasInStackCount * 2 - 1 {

            let button = IndexedUIButton(type: .system)

            if index < areasInStackCount {
                leftStack.addArrangedSubview(button)
            } else {
                rightStack.addArrangedSubview(button)
            }

            buttons.append(button)
            button.setIndex(index: index)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        for index in 0 ... buttons.count - 1 {
            customiseButton(buttons[index], animated: false)
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
        selectedButtonsCount = Int(testTime / (selectDuration! + intervalDuration!))
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

            guard let nNlevel = level, let nNDifficultyIndex = difficultyIndex else {
                return
            }

            ScoreRepositoryImpl.saveAnswers(points: Double(100 * correctTapSummaryCounter / selectSummaryCounter),
                                            level: nNlevel,
                                            difficulty: Double(Difficulty.multipliers[nNDifficultyIndex]))

            let alert = UIAlertController(title: "Score",
                                          message: "You scored " + String(Int(100 * correctTapSummaryCounter / selectSummaryCounter)) + " of 100",
                                          preferredStyle: UIAlertController.Style.alert)

            let alertAction = UIAlertAction(title: "Exit",
                                            style: UIAlertAction.Style.default,
                                            handler: { _ in
                                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                guard let newViewController = storyBoard.instantiateViewController(identifier: "entry")
                                                    as? UITabBarController else {
                                                    return
                                                }
                                                self.navigationController?.pushViewController(newViewController, animated: true)
            })
            alertAction.setValue(ColorScheme.tintColor, forKey: "titleTextColor")
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
            return

        } else {

            selectButton(index: Int.random(in: 0 ... buttons.count - 1))

        }

        testCounter += 1

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

            var colorIndex = index

            if colorIndex > self.areasInStackCount - 1 {
                colorIndex += 1
            }

            var backgroundColor = self.evenButtonColor

            if !colorIndex.isEven() {
                backgroundColor = self.notEvenButtonColor
            }

            if currentTappedIndex == index {

                backgroundColor = backgroundColor.modified(withAdditionalHue: 0.0, additionalSaturation: 0.0, additionalBrightness: brightnessTermWhileTapped)
            }

            UIView.animate(withDuration: animationIntroDuration,
                           animations: {
                                self.buttons[index].backgroundColor = backgroundColor
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

        currentTappedIndex = index
        isTappedJustNow = true

        sender.backgroundColor = sender.backgroundColor?.modified(withAdditionalHue: 0.0,
                                                                  additionalSaturation: 0.0,
                                                                  additionalBrightness: brightnessTermWhileTapped)
    }

    @objc func untap(sender: IndexedUIButton) {

        currentTappedIndex = nil

        sender.backgroundColor = sender.backgroundColor?.modified(withAdditionalHue: 0.0,
                                                                  additionalSaturation: 0.0,
                                                                  additionalBrightness: -brightnessTermWhileTapped)
    }

    func customiseButton(_ button: IndexedUIButton, animated: Bool) {

        if animated {
            UIView.animate(withDuration: animationIntroDuration, animations: {
                button.layer.cornerRadius = self.buttonCornerRadius
                button.clipsToBounds = true
            })
        } else {
            button.layer.cornerRadius = buttonCornerRadius
            button.clipsToBounds = true
        }

        button.addTarget(self, action: #selector(WMSAreasViewController.tap(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(WMSAreasViewController.untap(sender:)), for: .touchUpInside)

        guard var index = button.getIndex() else {
            return
        }

        if index > areasInStackCount - 1 {
            index += 1
        }

        var backgroundColor = evenButtonColor

        if !index.isEven() {
            backgroundColor = notEvenButtonColor
        }

        if animated {
            UIView.animate(withDuration: animationIntroDuration, animations: {
                button.backgroundColor = backgroundColor
            })
        } else {
            button.backgroundColor = backgroundColor
        }
    }
}
