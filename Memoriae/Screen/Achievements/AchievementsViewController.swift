//
//  AchievementsViewController.swift
//  Memoriae
//
//  Created by panandafog on 03.05.2020.
//  Copyright © 2020 SheetCode Team. All rights reserved.
//

import UIKit

class AchievementsViewController: UIViewController {

    var levels: [[Level]]?
    var sections = [Section]()

    let HBW: CGFloat = 1
    let HBB: CGFloat = -0.1
    
    @IBOutlet private var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard var levelList = ResourcesManager.getLevels() else {
            return
        }

        levelList.sort(by: { $0.section < $1.section })
        var last = ""
        var currentSection = -1
        levels = [[Level]]()
        for index in 0...levelList.count - 1 {
            if last != levelList[index].section {
                if !last.isEmpty {
                    guard let level = levels?[currentSection] else {
                        return
                    }
                    sections.append(Section(name: last, items: level.sorted(by: { $0.title < $1.title })))
                }
                last = levelList[index].section
                currentSection += 1
                levels?.append([Level]())
            }
            levels?[currentSection].append(levelList[index])
        }

        if !last.isEmpty {
            guard let level = levels?[currentSection] else {
                return
            }
            sections.append(Section(name: last, items: level.sorted(by: { $0.title < $1.title })))
        }

        if !sections.isEmpty && sections[0].collapsed {
            for index in 0..<sections.count {
                levels?[index].removeAll()
            }
        }

        for section in 0..<sections.count {
            levels?[section].sort(by: { $0.title < $1.title })
        }

        table.rowHeight = AchievementsCell.cellHeight
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()

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
        guard let rowsInSection = levels?[section].count else {
            return 0
        }
        return rowsInSection
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = IndexedUIButton()
        sectionButton.setTitle(sections[section].name, for: .normal)
        sectionButton.backgroundColor = ColorScheme.tintColor
        sectionButton.setIndex(index: section)
        sectionButton.addTarget(self, action: #selector(self.hideSection(sender:)), for: .touchUpInside)

        sectionButton.layer.borderWidth = HBW

        sectionButton.layer.borderColor = ColorScheme.tintColor.modified(withAdditionalHue: 0.0, additionalSaturation: 0.0, additionalBrightness: HBB).cgColor

        return sectionButton
    }

    @objc func hideSection(sender: IndexedUIButton) {
        guard let section = sender.getIndex() else {
            return
        }
        table.beginUpdates()
        if self.sections[section].collapsed {
            levels?[section] = sections[section].items
            table.insertRows(at: indexPathsForSection(section: section), with: .top)
        } else {
            levels?[section].removeAll()
            table.deleteRows(at: indexPathsForSection(section: section), with: .top)
        }
        table.endUpdates()
        sections[section].collapsed = !sections[section].collapsed
    }

    func indexPathsForSection(section: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for row in 0..<self.sections[section].items.count {
            indexPaths.append(IndexPath(row: row,
                                        section: section))
        }
        return indexPaths
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsCell", for: indexPath) as? AchievementsCell else {
            fatalError("Table view is not configured")
        }
        guard let nNData = levels else {
            fatalError("Data is null")
        }
        cell.setup(with: nNData[indexPath.section][indexPath.row])
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
