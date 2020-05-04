//
//  AchievementsViewController.swift
//  Memoriae
//
//  Created by panandafog on 03.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    var levels: [Level]?

    @IBOutlet private var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        levels = ResourcesManager.getLevels()

        table.rowHeight = AchievementsCell.cellHeight
        table.dataSource = self
        table.delegate = self

        table.refreshControl = UIRefreshControl()
        table.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc func handleRefreshControl() {

        DispatchQueue.main.async {
            self.table.reloadData()
        }

        table.refreshControl?.endRefreshing()
    }
}

extension AchievementsViewController: UITableViewDataSource {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsCell", for: indexPath) as? AchievementsCell else {
            fatalError("Table view is not configured")
        }
        guard let nNData = levels else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as? AchievementsCell
        cell?.submitProgress()
    }
}

extension AchievementsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
