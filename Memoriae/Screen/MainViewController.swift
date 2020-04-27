//
//  ViewController.swift
//  Memoriae
//
//  Created by panandafog on 31.03.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let rowHeight: CGFloat = 200
    var data: [Level]?

    @IBOutlet private var tableView: UITableView!
    @IBOutlet weak var topBar: UINavigationItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //topBar.title = "Memoriae"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let asset = NSDataAsset(name: "levels.json")
        guard let assetData = asset?.data else {
            return
        }
        data = try? JSONDecoder().decode([Level].self, from: assetData)
        tableView.rowHeight = rowHeight
        LevelCell.viewController = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case self.tableView:
            guard let nNData = data else {
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
        guard let nNData = data else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.row], controller: self, index: indexPath)
        return cell
    }
}
