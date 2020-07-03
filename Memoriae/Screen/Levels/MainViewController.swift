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

        table.rowHeight = UITableView.automaticDimension
        LevelCell.viewController = self
        table.dataSource = self
        table.delegate = self
        table.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
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
