//
//  ViewController.swift
//  Memoriae
//
//  Created by panandafog on 31.03.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var levels: [[Level]]?

    @IBOutlet private var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard var levelList = ResourcesManager.getLevels() else {
            return
        }

        levelList.sort(by: { $0.section > $1.section })
        var last = ""
        var currentSection = -1
        levels = [[Level]]()
        for index in 0...levelList.count - 1 {
            if last != levelList[index].section {
                last = levelList[index].section
                currentSection += 1
                levels?.append([Level]())
            }
            levels?[currentSection].append(levelList[index])
        }

        guard let sections = levels?.count else {
            return
        }

        for section in 0...sections - 1 {
            levels?[section].sort(by: { $0.title < $1.title })
        }

        table.rowHeight = UITableView.automaticDimension
        LevelCell.viewController = self
        table.dataSource = self
        table.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = levels?.count else {
            return 0
        }
        return sections
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let name = levels?[section][0].section else {
            return nil
        }
        return name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nNData = levels else {
            return 0
        }
        return nNData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LevelCell", for: indexPath) as? LevelCell else {
            fatalError("Table view is not configured")
        }
        guard let nNData = levels else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.section][indexPath.row], controller: self, index: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let level = levels?[indexPath.section][indexPath.row] else {
            return
        }
        guard let previewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LevelPreviewController") as? LevelPreviewController else {
                return
        }

        previewController.level = level
        navigationController?.pushViewController(previewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
