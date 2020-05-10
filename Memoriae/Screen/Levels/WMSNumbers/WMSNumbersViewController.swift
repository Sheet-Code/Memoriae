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
    var difficulty: Float?
    var numbersCount = 0
    var randNumbers = [Int]()
    var userAnswers = [Int]()
    var buttons = [UIButton]()
    
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

        setupButtons()
        
    }
    
    @IBAction private func startGame(sender: UIButton) {
        sender.setTitle("Go!", for: .normal)
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(randomNumbers), userInfo: nil, repeats: true)
    }
    
    @IBAction private func exit(_ sender: Any) {

        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(identifier: "entry") as? UITabBarController else {
            return
        }

        navigationController?.pushViewController(newViewController, animated: true)
    }
    
    func setTest(level: Level, difficulty: Float) {
        self.level = level
        self.difficulty = difficulty
    }
    
    @objc func randomNumbers(timer: Timer) {
        if numbersCount > 5 {
            timer.invalidate()
            mainButton.setTitle("That's all", for: .normal)
            numbersCount = 0
            
            mainButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 36)
            for butt in buttons {
                butt.addTarget(self, action: #selector(WMSNumbersViewController.checker(sender:)), for: .touchUpInside)
            }
            
            return
        }
        let random = Int.random(in: 0..<10)
        randNumbers.append(random)
        mainButton.setTitle(String(random), for: .normal)
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

    @objc func checker(sender: UIButton) {
        //проверка после ввода последовательности чисел
        //sender.tintColor = .systemRed
        print(sender.title(for: .normal))
    }
    
    func setTest(level: Level, difficultyIndex: Int) {
        //
    }
    
}
