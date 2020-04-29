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

    @IBAction private func submitAnswers(_ sender: Any) {
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let questions = level?.target?.questions else {
            return
        }
        tableData = questions
        //table.rowHeight = 200
        table.rowHeight = UITableView.automaticDimension
        LevelCell.viewController = self
        table.dataSource = self
        table.delegate = self
        table.allowsSelection = false
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

