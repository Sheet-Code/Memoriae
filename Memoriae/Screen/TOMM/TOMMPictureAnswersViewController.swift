//
//  TOMMPictureAnswersViewController.swift
//  Memoriae
//
//  Created by panandafog on 27.04.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class TOMMPictureAnswersViewController: UIViewController {

    var level: Level?
    var tableData: [Question]?

    @IBOutlet private var table: UITableView!
    @IBOutlet private var submitButton: UIButton!
    @IBOutlet private var exitButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let questions = level?.target?.questions else {
            return
        }
        tableData = questions
        table.rowHeight = UITableView.automaticDimension
        LevelCell.viewController = self
        table.dataSource = self
        table.delegate = self
        table.allowsSelection = false

        exitButton.center = submitButton.center
        exitButton.center.x += view.bounds.width
    }

    @IBAction private func submitAnswers(_ sender: Any) {
        var answers: [Int] = []

        for index in 0...table.numberOfRows(inSection: 0) - 1 {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = table.cellForRow(at: indexPath) as? TOMMAnswerCell else {
                return
            }
            guard let selected = cell.getSelectedAnswer() else {
                let alert = UIAlertController(title: "Questions",
                                              message: (String(index + 1) + " number question not answered"),
                                              preferredStyle: UIAlertController.Style.alert)
                let alertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alertAction.setValue(UIColor.systemOrange, forKey: "titleTextColor")
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            answers.append(selected)
        }

        guard let questions = tableData else {
            return
        }

        var right = 0

        for index in 0...answers.count - 1 where questions[index].rightAnswer == answers[index] {
            right += 1
        }

        //        let alert = UIAlertController(title: "Answers",
        //                                      message: (String(right) + "/" + String(answers.count) + " right!"),
        //                                      preferredStyle: UIAlertController.Style.alert)
        //        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        //        self.present(alert, animated: true, completion: nil)

        for index in 0...table.numberOfRows(inSection: 0) - 1 {
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = table.cellForRow(at: indexPath) as? TOMMAnswerCell else {
                return
            }
            cell.submitAnswer()
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
        cell.setup(with: nNData[indexPath.row], controller: self, index: indexPath)
        return cell
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
        cell.setup(with: nNData[indexPath.row], controller: self, index: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TOMMPictureAnswersViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
