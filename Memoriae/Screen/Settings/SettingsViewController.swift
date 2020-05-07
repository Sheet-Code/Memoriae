//
//  SettingsViewController.swift
//  Memoriae
//
//  Created by panandafog on 04.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    private var cellsDetails = [[SettingsCellDetails]]()

    @IBOutlet private var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function)

        cellsDetails.append([
                SettingsCellDetails.action(title: "Delete all progress",
                                           action: #selector(SettingsViewController.clearScoresRealm(sender:)),
                                           target: self)
        ])

        cellsDetails.append([SettingsCellDetails.selectColor])

        table.dataSource = self
        table.delegate = self
    }
}

extension SettingsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        cellsDetails.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.table:
            return cellsDetails[section].count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row > cellsDetails.count - 1 {
            fatalError("Data is null")
        }

        let identifier: String

        switch cellsDetails[indexPath.section][indexPath.row] {

        case .action(title: _, action: _, target: _):

            identifier = "SimpleActionCell"

        case .switcher:

            identifier = "SimpleSwitcherCell"

        case .details:

            identifier = "DetailsCell"

        case .selectColor:

            identifier = "SelectingColorCell"

        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? SettingsCell else {
            fatalError("Table view is not configured")
        }

        cell.setup(with: cellsDetails[indexPath.section][indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

        case 0:
            return "Achievements"

        case 1:
            return "Appearance"

        default:
            return ""
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    @objc func clearScoresRealm(sender: Any) {

        let alert = UIAlertController(title: "Delete all progress?",
                                      message: "This action cannot be undone. All records of completed levels will be deleted",
                                      preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            ScoreRepositoryImpl.clear()
        })

        let canсelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        canсelAction.setValue(ColorScheme.tintColor, forKey: "titleTextColor")

        alert.addAction(deleteAction)
        alert.addAction(canсelAction)

        self.present(alert, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
