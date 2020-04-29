//
//  TOMMPictureViewController.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class TOMMPictureViewController: UIViewController {

    var level: Level?

    private var timerCounter: Float = 0
    private var waitTime: Float = 0
    private let timeStep: Float = 0.01

    @IBOutlet private var progressBar: UIProgressView!
    @IBOutlet private var image: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let target = level?.target else {
            return
        }
        image.image = UIImage(named: target.picture)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let target = level?.target else {
            return
        }
        waitTime = Float(target.time)

        Timer.scheduledTimer(timeInterval: TimeInterval(timeStep), target: self, selector: #selector(updateProgressBar), userInfo: nil, repeats: true)
    }

    @objc func updateProgressBar(timer: Timer) {
        timerCounter += timeStep
        if timerCounter >= waitTime {
            timer.invalidate()
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let newViewController = storyBoard.instantiateViewController(identifier: "TOMMPictureAnswersViewController") as? TOMMPictureAnswersViewController else {
                return
            }
            newViewController.level = self.level
            self.navigationController?.pushViewController(newViewController, animated: true)
            self.navigationController?.isNavigationBarHidden = true
        }
        progressBar.setProgress(Float(timerCounter / waitTime), animated: true)
    }
}