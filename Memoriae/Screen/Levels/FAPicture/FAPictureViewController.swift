//
//  FAPictureViewController.swift
//  Memoriae
//
//  Created by panandafog on 22.06.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class FAPictureViewController: UIViewController, LevelViewController {

    private var level: Level?
    private var difficultyIndex: Int?

    private var pairCount: Int = 0
    private var tries: Int = 0
    private var right: Int = 0
    private var answers: Int = 0
    private var pressedBefore: IndexedUIButton?

    private let stackSpacing: CGFloat = 10
    private let elementInRow: Int = 3
    private let animationIntroDuration = 0.2
    private let animationEndDuration = 1.0

    private var allowPress: Bool = true

    private var freeNumbers = [Int]()
    private var buttons = [IndexedUIButton]()
    private var additionalStacks = [UIStackView]()

    @IBOutlet private var stack: UIStackView!
    @IBOutlet private var triesLabel: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        stack.spacing = stackSpacing

        guard let difficulty = difficultyIndex else {
            return
        }

        pairCount = (difficulty + 1) * 3
        tries = (difficulty + 1) * 2
        triesLabel.text = "Free tries: " + String(tries)

        for index in 0 ... pairCount * 2 - 1 {
            freeNumbers.append(index / 2)
        }

        for index in 0 ... pairCount * 2 - 1 {
            let place = Int.random(in: 0..<freeNumbers.count)
            if (index % elementInRow) == 0 {
                let newStack = UIStackView()
                newStack.axis = .horizontal
                newStack.spacing = stackSpacing
                newStack.distribution = .fillEqually

                stack.addArrangedSubview(newStack)
                additionalStacks.append(newStack)
            }
            guard let currentStack = additionalStacks.last else {
                return
            }

            let button = IndexedUIButton(type: .system)
            button.backgroundColor = ColorScheme.tintColor
            currentStack.addArrangedSubview(button)
            button.setIndex(index: freeNumbers[place])
            button.setTitle(String(freeNumbers[place]), for: .normal)
            button.addTarget(self, action: #selector(self.selected(sender:)), for: .touchUpInside)
            buttons.append(button)
            freeNumbers.remove(at: place)
        }
    }

    @objc func selected(sender: IndexedUIButton) {
        if sender.tintColor == .white || !allowPress {
            return
        }
        self.allowPress = false
        UIView.animate(withDuration: animationIntroDuration,
                       animations: {
                        sender.tintColor = .white
        },
                       completion: { _ in
                        guard let pressed = self.pressedBefore else {
                            self.pressedBefore = sender
                            self.allowPress = true
                            return
                        }
                        let equal = sender.getIndex() == pressed.getIndex()
                        UIView.animate(withDuration: self.animationEndDuration,
                                       animations: {
                                        if equal {
                                            sender.backgroundColor = UIColor.clear
                                            pressed.backgroundColor = UIColor.clear
                                            sender.tintColor = UIColor.clear
                                            pressed.tintColor = UIColor.clear
                                        } else {
                                            sender.tintColor = ColorScheme.tintColor
                                            pressed.tintColor = ColorScheme.tintColor
                                        }
                        },
                                       completion: { _ in
                                        if equal {
                                            sender.isEnabled = false
                                            pressed.isEnabled = false
                                            self.right += 1
                                            self.answers += 1
                                        } else {
                                            if self.tries > 0 {
                                                self.tries -= 1
                                                self.triesLabel.text = "Free tries: " + String(self.tries)
                                            } else {
                                                self.answers += 1
                                            }
                                        }
                                        self.pressedBefore = nil
                                        self.allowPress = true

                                        if self.right == self.pairCount {
                                            guard let nNlevel = self.level, let nNDifficultyIndex = self.difficultyIndex else {
                                                return
                                            }

                                            ScoreRepositoryImpl.saveAnswers(points: Double(100 * self.right / self.answers),
                                                                            level: nNlevel,
                                                                            difficulty: Double(Difficulty.multipliers[nNDifficultyIndex]))
                                            let alert = UIAlertController(title: "Score",
                                                                          message: "You scored " + String(Int(100 * self.right / self.answers)) + " of 100",
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
                                        }
                        })
        })
    }

    func setTest(level: Level, difficultyIndex: Int) {
        self.level = level
        self.difficultyIndex = difficultyIndex
    }
}
