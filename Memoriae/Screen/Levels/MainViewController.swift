//
//  ViewController.swift
//  Memoriae
//
//  Created by panandafog on 31.03.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var levels: [Level]?

    @IBOutlet private var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        levels = ResourcesManager.getLevels()
        
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.table:
            guard let nNData = levels else {
                return 0
            }
            return nNData.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LevelCell", for: indexPath) as? LevelCell else {
            fatalError("Table view is not configured")
        }
        guard let nNData = levels else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.row], controller: self, index: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let level = levels?[indexPath.row] else {
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
