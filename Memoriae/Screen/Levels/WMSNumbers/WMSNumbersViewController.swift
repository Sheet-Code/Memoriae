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
  @IBOutlet private var bigCircle: UILabel!
  
  @IBOutlet private var button1: UIButton!
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    bigCircle.layer.cornerRadius = 100
    bigCircle.layer.masksToBounds = true
    
    button1.isUserInteractionEnabled = true
  }
  func setTest(level: Level, difficulty: Float) {
    self.level = level
    self.difficulty = difficulty
  }
}
