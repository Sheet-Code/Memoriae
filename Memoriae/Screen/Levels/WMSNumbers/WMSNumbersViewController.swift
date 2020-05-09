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
  var counter = 0
  var array = [Int]()
  var right = 0
  var buttons = [IndexedUIButton]()
  var userAnswers = [Int]()
  
  @IBOutlet private var bigCircle: UIButton!
  
  @IBOutlet private var button0: IndexedUIButton!
  
  @IBOutlet private var button1: IndexedUIButton!
  
  @IBOutlet private var button2: IndexedUIButton!
  
  @IBOutlet private var button3: IndexedUIButton!
  
  @IBOutlet private var button4: IndexedUIButton!
  
  @IBOutlet private var button5: IndexedUIButton!
  
  @IBOutlet private var button6: IndexedUIButton!
  
  @IBOutlet private var button7: IndexedUIButton!
  
  @IBOutlet private var button8: IndexedUIButton!
  
  @IBOutlet private var button9: IndexedUIButton!
  
  @objc func checker(sender: IndexedUIButton) {
    if array[counter] == sender.getIndex() {
      right += 1
      sender.tintColor = .systemGreen
      sleep(1)
      sender.tintColor = .systemOrange
    } else {
      sender.tintColor = .systemRed
      sleep(1)
      sender.tintColor = .systemOrange
    }
    counter += 1
  }
  @IBAction private func huisosat(sender: UIButton) {
    sender.setTitle("StarHHhhhhh", for: .normal)
    Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(randomNumbers), userInfo: nil, repeats: true)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
      buttons[index].addTarget(self, action: #selector(WMSNumbersViewController.checker(sender:)), for: .touchUpInside)
      //buttons[index].setIndex(index: index)
    }
    bigCircle.layer.cornerRadius = 80
    bigCircle.layer.masksToBounds = true
    bigCircle.setTitle("Start", for: .normal)
  }
  func setTest(level: Level, difficulty: Float) {
    self.level = level
    self.difficulty = difficulty
  }

  @objc func randomNumbers(timer: Timer) {
    if counter > 5 {
      timer.invalidate()
      bigCircle.setTitle("That's all", for: .normal)
      counter = 0
      for index in 0...9 {
        buttons[index].isHidden = false
      }
      return
      
    }
    let random = Int.random(in: 0..<10)
    array.append(random)
    bigCircle.setTitle(String(random), for: .normal)
    counter += 1
  }
  
    func checkAnswers(){
      for index in 0...9 {
        userAnswers[index].append(array[index])
        if String(array[index]) == buttons[index].title(for: <#T##UIControl.State#>)
        {
          
        }
      }
  }
  
}
