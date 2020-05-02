//
//  TOMMPictureAnswersViewController.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class TOMMPictureAnswersViewController: UIViewController {
    
    private var level: Level?
    private var difficulty: Float?
    private var targetNumber: Int?
    private var currentTarget: Target?

    private var tableData: [Question]?
    private var answers: [Int?]?
    private var answersAreSubmitted = false
    
    @IBOutlet private var table: UITableView!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var exitButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let questions = currentTarget?.questions else {
            return
        }
        
        tableData = questions
        table.rowHeight = UITableView.automaticDimension
        LevelCell.viewController = self
        table.dataSource = self
        table.delegate = self
        table.allowsSelection = false
        
        exitButton.center.x = view.bounds.width * 2
        
        guard let count = currentTarget?.questions.count else {
            return
        }
        
        var answers = [Int?]()
        for _ in 0...count {
            answers.append(nil)
        }
        self.answers = answers
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        exitButton.center.y = submitButton.center.y
        exitButton.center.x = submitButton.center.x + view.bounds.width
    }
    
    @IBAction private func submitAnswers(_ sender: Any) {
        
        var answers: [Int] = []
        
        for index in 0...table.numberOfRows(inSection: 0) - 1 {
            
            guard let selected = self.answers?[index] else {
                let alert = UIAlertController(title: "That's not all!",
                                              message: "Question number " + (String(index + 1) + " is not answered"),
                                              preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertAction.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            answers.append(selected)
        }
        
        answersAreSubmitted = true
        
        guard let questions = tableData else {
            return
        }
        
        var right = 0
        for index in 0...answers.count - 1 where questions[index].rightAnswer == answers[index] {
            right += 1
        }
        
        guard let nNlevel = level else {
            return
        }
        guard let nNdifficulty = difficulty else {
            return
        }
        
        ScoreRepositoryImpl.saveAnswers(right: right, level: nNlevel, difficulty: nNdifficulty, questions: questions)
        
        //        let repo = ScoreRepositoryImpl()
        //        guard let points = repo.get().last?.points else {
        //            return
        //        }
        //
        //                let alert = UIAlertController(title: "Results sent",
        //                                              message: String(points),
        //                                              preferredStyle: UIAlertController.Style.alert)
        //                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //                self.present(alert, animated: true, completion: nil)
        
        for index in 0...table.numberOfRows(inSection: 0) - 1 {
            
            let indexPath = IndexPath(row: index, section: 0)
            let cell = table.cellForRow(at: indexPath) as? TOMMAnswerCell
            
            if cell != nil {
                guard let nNcell = cell else {
                    return
                }
                nNcell.submitAnswer()
            }
        }
        
        UIView.animate(withDuration: 0.7, animations: {
            self.submitButton.center.x -= self.view.bounds.width
            self.exitButton.center.x -= self.view.bounds.width
        })
    }
    
    @IBAction private func exit(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let newViewController = storyBoard.instantiateViewController(identifier: "entry") as? UITabBarController else {
            return
        }
        
        navigationController?.pushViewController(newViewController, animated: true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func tableView(_ tableView: UITableView, answerCellForRowAt indexPath: IndexPath) -> TOMMAnswerCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TOMMAnswerCell", for: indexPath) as? TOMMAnswerCell else {
            fatalError("Table view is not configured")
        }
        guard let nNData = tableData else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.row], answersAreSubmitted: answersAreSubmitted, controller: self, index: indexPath)
        return cell
    }
    
    func selectAnswer(index: Int, answer: Int) {
        
        guard var answers = self.answers else {
            return
        }
        
        answers[index] = answer
        self.answers = answers
    }
    
    func getSelectedAnswer(index: Int) -> Int? {
        answers?[index]
    }

    func setTestDetails(level: Level?, difficulty: Float?, targetNumber: Int?, currentTarget: Target?) {

        self.level = level
        self.difficulty = difficulty
        self.targetNumber = targetNumber
        self.currentTarget = currentTarget
    }
}

// MARK: - UITableViewDataSource
extension TOMMPictureAnswersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.table:
            guard let nNData = tableData else {
                return 0
            }
            return nNData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TOMMAnswerCell", for: indexPath) as? TOMMAnswerCell else {
            fatalError("Table view is not configured")
        }
        guard let nNData = tableData else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.row], answersAreSubmitted: answersAreSubmitted, controller: self, index: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TOMMPictureAnswersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
