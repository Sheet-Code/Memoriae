//
//  WMSNumbersViewController.swift
//  Memoriae
//
//  Created by Vladimir GL on 02.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class WMSNumbersViewController: UIViewController, LevelViewController {
    
    var level: Level?
    var difficulty = Float(0.0)
    var difficultyIndex: Int?
    var numbersCount = 0
    var randNumbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9].shuffled()
    var userAnswers = [Int]()
    var buttons = [UIButton]()
    var isChecked = false
    
    @IBOutlet private var mainButton: UIButton!
    @IBOutlet private var button0: UIButton!
    @IBOutlet private var button1: UIButton!
    @IBOutlet private var button2: UIButton!
    @IBOutlet private var button3: UIButton!
    @IBOutlet private var button4: UIButton!
    @IBOutlet private var button5: UIButton!
    @IBOutlet private var button6: UIButton!
    @IBOutlet private var button7: UIButton!
    @IBOutlet private var button8: UIButton!
    @IBOutlet private var button9: UIButton!
    @IBOutlet private var submit: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainButton.layer.cornerRadius = 0.5 * mainButton.bounds.size.width
        mainButton.layer.masksToBounds = true
        mainButton.setTitle("Start", for: .normal)
        mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 72)
        mainButton.setTitleColor(.white, for: .init())
        mainButton.backgroundColor = ColorScheme.tintColor
        submit.backgroundColor = ColorScheme.tintColor
        submit.isHidden = true
        
        setupButtons()
    }
    
    @IBAction private func startGame(sender: UIButton) {
        sender.setTitle("Go!", for: .normal)
        Timer.scheduledTimer(timeInterval: TimeInterval(difficulty), target: self, selector: #selector(randomNumbers), userInfo: nil, repeats: true)
    }
    
    @IBAction private func submit(_ sender: Any) {
        if !isChecked {
            guard let nNlevel = level, let nNDifficultyIndex = difficultyIndex else { return }
            
            var rightAnswers = 0
            for index in 0...userAnswers.count - 1 {
                if userAnswers[index] == randNumbers[index] {
                    rightAnswers += 1
                    showCorrectness(index: userAnswers[index], answerIsCorrect: true)
                } else {
                    showCorrectness(index: userAnswers[index], answerIsCorrect: false)
                }
            }
            
            ScoreRepositoryImpl.saveAnswers(points: Double(100 * rightAnswers / randNumbers.count),
                                            level: nNlevel,
                                            difficulty: Double(Difficulty.multipliers[nNDifficultyIndex]))
            isChecked = true
            submit.setTitle("Exit", for: .init())
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let newViewController = storyBoard.instantiateViewController(identifier: "entry") as? UITabBarController else {
                return
            }
            
            navigationController?.pushViewController(newViewController, animated: true)
        }
        
    }
    
    func showCorrectness(index: Int, answerIsCorrect: Bool) {
        UIView.animate(withDuration: 0.8, animations: {
            
            if answerIsCorrect {
                self.buttons[index].backgroundColor = .systemGreen
            } else {
                self.buttons[index].backgroundColor = .systemRed
            }
        })
    }
    
    func setTest(level: Level, difficultyIndex: Int) {
        self.level = level
        self.difficultyIndex = difficultyIndex
        self.difficulty = Difficulty.multipliers[difficultyIndex]
    }
    
    @objc func randomNumbers(timer: Timer) {
        if numbersCount > 9 {
            timer.invalidate()
            mainButton.setTitle("That's all", for: .normal)
            mainButton.isEnabled = false
            submit.isEnabled = true
            numbersCount = 0
            
            mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            for butt in buttons {
                butt.addTarget(self, action: #selector(WMSNumbersViewController.answerSelector(sender:)), for: .touchUpInside)
            }
            
            return
        }
        mainButton.setTitle(String(randNumbers[numbersCount]), for: .normal)
        numbersCount += 1
    }
    
    func setupButtons() {
        buttons.append(button0)
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        buttons.append(button4)
        buttons.append(button5)
        buttons.append(button6)
        buttons.append(button7)
        buttons.append(button8)
        buttons.append(button9)
        
        for index in 0...9 {
            buttons[index].setTitle(String(index), for: .normal)
            buttons[index].layer.cornerRadius = 0.5 * buttons[index].bounds.size.width
            buttons[index].layer.masksToBounds = true
            buttons[index].titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            buttons[index].setTitleColor(.white, for: .init())
            buttons[index].backgroundColor = ColorScheme.tintColor
        }
        
        submit.layer.masksToBounds = true
        submit.layer.cornerRadius = 0.5 * submit.bounds.size.height
        submit.titleLabel?.text = "Submit"
        submit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        submit.setTitleColor(.white, for: .init())
        
    }
    
    @objc func answerSelector(sender: UIButton) {
        sender.backgroundColor = sender.backgroundColor?.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: -0.2)
        
        guard let strTitle = sender.title(for: .normal), let intTitle = Int(strTitle) else {
            return
        }
        
        userAnswers.append(intTitle)
        sender.isEnabled = false
        
        if userAnswers.count == 10 {
            self.submit.isHidden = false
        }
        
    }
    
}
