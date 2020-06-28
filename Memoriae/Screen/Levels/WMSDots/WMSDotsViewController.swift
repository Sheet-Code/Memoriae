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
    private var difficultyIndex: Int?
    private var dotsCount: Int?
    private var dots: [IndexedUIButton] = []
    private var answeredDots: [IndexedUIButton] = []

    private var commonDotsCount = 7
    private var diameter = 60

    private let animationDuration = 1.7
    private let animationIntroDuration = 0.2
    private let highlightInterval = 0.8

    private let inactiveDotColor = UIColor.systemGray4
    private let activeDotColor = ColorScheme.tintColor

    private var timerIndex = 0

    @IBOutlet private var dotsView: UIView!
    @IBOutlet private var exitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let count = dotsCount else {
            return
        }

        for index in 0 ... count - 1 {
            dots.append(createDot(index: index))
        }

        exitButton.isHidden = true
        exitButton.setTitleColor(dotsView.backgroundColor, for: .init())
        exitButton.tintColor = ColorScheme.tintColor
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let dotsPositions = PointsGenerator.scatterObjects(area: dotsView.frame.size,
                                                           size: CGSize(width: diameter, height: diameter),
                                                           quantity: dots.count)

        for index in 0 ... dots.count - 1 {

            dots[index].center = dotsPositions[index]
            dotsView.addSubview(dots[index])
        }

        Timer.scheduledTimer(timeInterval: self.highlightInterval,
                             target: self,
                             selector: #selector(self.onTick),
                             userInfo: nil,
                             repeats: true)
    }

    @IBAction private func exit(_ sender: Any) {

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(identifier: "entry") as? UITabBarController else {
            return
        }

        navigationController?.pushViewController(newViewController, animated: true)
    }

    @objc func onTick(timer: Timer) {

        highlightDot(index: timerIndex)
        timerIndex += 1

        if timerIndex == dots.count {

            timer.invalidate()

            for index in 0 ... dots.count - 1 {

                dots[index].addTarget(self, action: #selector(WMSDotsViewController.pressed(sender:)), for: .touchUpInside)
            }
        }
    }

    @objc func pressed(sender: IndexedUIButton) {

        UIView.animate(withDuration: animationIntroDuration, animations: {
            sender.backgroundColor = ColorScheme.tintColor
        })

        sender.isEnabled = false
        answeredDots.append(sender)

        if answeredDots.count == dots.count {

            submitAnswers()

            Timer.scheduledTimer(timeInterval: self.highlightInterval * 2,
                                 target: self,
                                 selector: #selector(self.showExit(timer:)),
                                 userInfo: nil,
                                 repeats: true)
        }
    }

    @objc func showExit(timer: Timer) {

        self.exitButton.isHidden = false
        self.exitButton.isSelected = true
        self.dotsView.bringSubviewToFront(self.exitButton)

        timer.invalidate()
    }

    func startSelectingAnswers() {

        for index in 0 ... dots.count - 1 {

            dots[index].tintColor = ColorScheme.tintColor
        }
    }

    func submitAnswers() {

        guard let nNlevel = level, let nNDifficultyIndex = difficultyIndex else {
            return
        }

        var rightAnswers = 0

        for index in 0 ... answeredDots.count - 1 {

            if answeredDots[index].getIndex() == dots[index].getIndex() {
                rightAnswers += 1
                showCorrectness(dot: answeredDots[index], answerIsCorrect: true)
            } else {
                showCorrectness(dot: answeredDots[index], answerIsCorrect: false)
            }
        }

        ScoreRepositoryImpl.saveAnswers(points: Double(100 * rightAnswers / dots.count),
                                        level: nNlevel,
                                        difficulty: nNDifficultyIndex)
    }

    func setTest(level: Level, difficultyIndex: Int) {
        self.level = level
        self.difficultyIndex = difficultyIndex
        self.dotsCount = commonDotsCount + (difficultyIndex - 2)
    }

    func createDot(index: Int) -> IndexedUIButton {

        let dot = IndexedUIButton(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
        dot.layer.cornerRadius = 0.5 * dot.bounds.size.width
        dot.clipsToBounds = true
        dot.backgroundColor = UIColor(white: CGFloat(1), alpha: CGFloat(0))
        dot.setIndex(index: index)

        return dot
    }

    func highlightDot(index: Int) {

        if dots.count > index {

            UIView.animate(withDuration: animationIntroDuration,
                           animations: {
                            self.dots[index].backgroundColor = self.activeDotColor
            },
                           completion: { _ in
                            UIView.animate(withDuration: self.animationDuration - self.animationIntroDuration,
                                           animations: {
                                            self.dots[index].backgroundColor = self.inactiveDotColor
                            })
            })
        }
    }

    func showCorrectness(dot: IndexedUIButton, answerIsCorrect: Bool) {

        UIView.animate(withDuration: highlightInterval, animations: {

            if answerIsCorrect {
                dot.backgroundColor = .systemGreen
            } else {
                dot.backgroundColor = .systemRed
            }
        })
    }
}
