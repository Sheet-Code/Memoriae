//
//  FAPictureViewController.swift
//  Memoriae
//
//  Created by panandafog on 03.07.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class SchulteViewController: UIViewController, LevelViewController {
  
  private var level: Level?
  private var difficultyIndex: Int?
  
  private var target: Int = 0
  
  private var pressedBefore: IndexedUIButton?
  private var difficulty = Float(0.0)
  private let fontSize: CGFloat = 44
  private let pairMultiplier: Int = 3
  private let tryMultiplier: Int = 2
  private let radiusValue: CGFloat = 10
  private let stackSpacing: CGFloat = 10
  private let elementInRow: Int = 3
  private let animationIntroDuration = 0.2
  private let animationEndDuration = 1.0
  
  private var allowPress: Bool = true
  
  private var freeNumbers = [Int]()
  private var buttons = [IndexedUIButton]()
  private var additionalStacks = [UIStackView]()
  private var mistakesCounter: Int = 0
  
  @IBOutlet private var stack: UIStackView!
  @IBOutlet private var triesLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    stack.spacing = stackSpacing
    
    guard let index = difficultyIndex,
      let difficulty = level?.difficulties?[index].multipliers?[0] else {
        return
    }
    self.difficulty = difficulty
    target = 0
    triesLabel.text = "Press " + String(target)
    
    for index in 0 ... 11 {
      freeNumbers.append(index)
    }
    
    for index in 0 ... 11 {
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
      button.tintColor = ColorScheme.tintColor
      button.layer.cornerRadius = radiusValue
      currentStack.addArrangedSubview(button)
      button.setIndex(index: freeNumbers[place])
      button.setTitle(String(freeNumbers[place]), for: .normal)
      button.titleLabel?.font = .italicSystemFont(ofSize: fontSize)
      button.addTarget(self, action: #selector(self.selected(sender:)), for: .touchUpInside)
      buttons.append(button)
      freeNumbers.remove(at: place)
      triesLabel.text = "Tap the screen to start the game"
      
    }
    
  }
  
  @IBAction private func startGame(sender: UIButton) {
    sender.isHidden = true
    showCells()
    Timer.scheduledTimer(timeInterval: TimeInterval(difficulty), target: self, selector: #selector(hideCells), userInfo: nil, repeats: false)
  }
  
  @objc func hideCells() {
    for ind in 0...11 {
      buttons[ind].tintColor = ColorScheme.tintColor
      buttons[ind].isEnabled = true
    }
    triesLabel.text = "Press 0"
  }
  func showCells() {
    for ind in 0...11 {
      buttons[ind].tintColor = .black
      buttons[ind].isEnabled = false
    }
    triesLabel.text = "You have " + String(Int(difficulty)) + " seconds to remember numbers"
  }
  
  @objc func selected(sender: IndexedUIButton) {
    guard let index = sender.getIndex() else { return }
    if target == index {
      target += 1
      triesLabel.text = "Press " + String(target)
      sender.isEnabled = false
      sender.tintColor = .black
      sender.backgroundColor = sender.backgroundColor?.modified(withAdditionalHue: 0, additionalSaturation: 0, additionalBrightness: -0.2)
    } else { mistakesCounter += 1 }
    guard let nNlevel = level else { return }
    if mistakesCounter >= 20 {
      let alert = UIAlertController(title: "Warning",
                                    message: "Too much mistakes " + String(mistakesCounter),
                                    preferredStyle: UIAlertController.Style.alert)
      let alertAction = UIAlertAction(title: "Exit",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        guard let newViewController = storyBoard.instantiateViewController(identifier: "entry")
                                          as? UITabBarController else { return }
                                        self.navigationController?.pushViewController(newViewController, animated: true)
      })
      alertAction.setValue(ColorScheme.tintColor, forKey: "titleTextColor")
      alert.addAction(alertAction)
      self.present(alert, animated: true, completion: nil)
    }
    if target == 12 {
      triesLabel.text = "Game over"
      guard let index = difficultyIndex else { return }
      ScoreRepositoryImpl.saveAnswers(points: Double(100 - (mistakesCounter * 5)), level: nNlevel, difficulty: index)
      let alert = UIAlertController(title: "Score",
                                    message: "You scored " + String(100 - mistakesCounter * 5) + " of 100",
                                    preferredStyle: UIAlertController.Style.alert)
      let alertAction = UIAlertAction(title: "Exit",
                                      style: UIAlertAction.Style.default,
                                      handler: { _ in
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        guard let newViewController = storyBoard.instantiateViewController(identifier: "entry")
                                          as? UITabBarController else { return }
                                        self.navigationController?.pushViewController(newViewController, animated: true)
      })
      alertAction.setValue(ColorScheme.tintColor, forKey: "titleTextColor")
      alert.addAction(alertAction)
      self.present(alert, animated: true, completion: nil)
    }
  }

  func setTest(level: Level, difficultyIndex: Int) {
    self.level = level
    self.difficultyIndex = difficultyIndex
  }
}
