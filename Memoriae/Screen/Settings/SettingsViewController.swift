//
//  SettingsViewController.swift
//  Memoriae
//
//  Created by panandafog on 04.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private var cellsDetails: [SettingsCellDetails] = []

    @IBOutlet private var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function)

        cellsDetails.append(SettingsCellDetails.action(
            title: "Delete all progress",
            action: #selector(SettingsViewController.clearScoresRealm(sender:)),
            target: self))

        table.dataSource = self
        table.delegate = self

        //table.register(SettingsCell, forCellReuseIdentifier: "SettingsCell")
    }
}

extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.table:
            return cellsDetails.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row > cellsDetails.count - 1 {
            fatalError("Data is null")
        }

        let identifier: String

        switch cellsDetails[indexPath.row] {

        case .action(title: _, action: _, target: _):

            identifier = "SimpleActionCell"

        case .switcher:

            identifier = "SimpleSwitcherCell"

        case .details:

            identifier = "DetailsCell"

        default:

            fatalError("Unknown cell type")
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SettingsCell else {
            fatalError("Table view is not configured")
        }

        cell.setup(with: cellsDetails[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Achievements"
        } else {
            return ""
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    @objc func clearScoresRealm(sender: Any) {
        ScoreRepositoryImpl.clear()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
